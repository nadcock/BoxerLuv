//
//  CoreDataStack.swift
//  BoxerLuv
//
//  Created by Nick on 7/7/16.
//  Copyright © 2016 Nick Adcock. All rights reserved.
//


import CoreData

// MARK:  - TypeAliases
typealias BatchTask=(_ workerContext: NSManagedObjectContext) -> ()

// MARK:  - Notifications
enum CoreDataStackNotifications : String{
    case ImportingTaskDidFinish = "ImportingTaskDidFinish"
}
// MARK:  - Main
struct CoreDataStack {
    
    // MARK:  - Properties
    fileprivate let model : NSManagedObjectModel
    fileprivate let coordinator : NSPersistentStoreCoordinator
    fileprivate let modelURL : URL
    fileprivate let dbURL : URL
    fileprivate let persistingContext : NSManagedObjectContext
    fileprivate let backgroundContext : NSManagedObjectContext
    let context : NSManagedObjectContext
    
    
    // MARK:  - Initializers
    init?(modelName: String){
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil}
        
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else{
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // Create a persistingContext (private queue) and a child one (main queue)
        // create a context and add connect it to the coordinator
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.name = "Persisting"
        persistingContext.persistentStoreCoordinator = coordinator
        
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        context.name = "Main"
        
        
        // Create a background context child of main context
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        backgroundContext.name = "Background"
        
        
        
        // Add a SQLite store located in the documents folder
        let fm = FileManager.default
        
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        
        
        do{
            try addStoreTo(coordinator: coordinator,
                           storeType: NSSQLiteStoreType,
                           configuration: nil,
                           storeURL: dbURL,
                           options: nil)
            
        }catch{
            print("unable to add store at \(dbURL)")
        }
        
        
        
        
        
    }
    
    // MARK:  - Utils
    func addStoreTo(coordinator coord : NSPersistentStoreCoordinator,
                    storeType: String,
                    configuration: String?,
                    storeURL: URL,
                    options : [AnyHashable: Any]?) throws{
        
        try coord.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
        
    }
}


// MARK:  - Removing data
extension CoreDataStack  {
    
    func dropAllData() throws{
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        
        try addStoreTo(coordinator: self.coordinator, storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
        
        
    }
}

// MARK:  - Batch processing in the background
extension CoreDataStack{
    
    
    func performBackgroundBatchOperation(_ batch: @escaping BatchTask){
        
        backgroundContext.perform(){
            batch(self.backgroundContext)
            
            // Save it to the parent context, so normal saving
            // can work
            do{
                try self.backgroundContext.save()
            }catch{
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}

// MARK:  - Heavy processing in the background.
// Use this if importing a gazillion objects.
extension CoreDataStack {
    
    func performBackgroundImportingBatchOperation(_ batch: @escaping BatchTask) {
        
        // Create temp coordinator
        let tmpCoord = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        
        do{
            try addStoreTo(coordinator: tmpCoord, storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
        }catch{
            fatalError("Error adding a SQLite Store: \(error)")
        }
        
        // Create temp context
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.name = "Importer"
        moc.persistentStoreCoordinator = tmpCoord
        
        // Run the batch task, save the contents of the moc & notify
        moc.perform(){
            batch(moc)
            
            do {
                try moc.save()
            }catch{
                fatalError("Error saving importer moc: \(moc)")
            }
            
            let nc = NotificationCenter.default
            let n = Notification(name: Notification.Name(rawValue: CoreDataStackNotifications.ImportingTaskDidFinish.rawValue),
                                 object: nil)
            nc.post(n)
        }
        
    }
}


// MARK:  - Save
extension CoreDataStack {
    
    func save() {
        // We call this synchronously, but it's a very fast
        // operation (it doesn't hit the disk). We need to know
        // when it ends so we can call the next save (on the persisting
        // context). This last one might take some time and is done
        // in a background queue
        
        context.performAndWait(){
            
            if self.context.hasChanges{
                do{
                    try self.context.save()
                }catch{
                    fatalError("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.persistingContext.perform(){
                    do{
                        try self.persistingContext.save()
                    }catch{
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
                
                
            }
        }
        
        
    }
    
    
    func autoSave(_ delayInSeconds : Int){
        
        if delayInSeconds > 0 {
            save()
            
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.autoSave(delayInSeconds)
            })
            
        }
    }
}


//class CoreDataStack {
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Model")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                fatalError("Unresolved error \(error), \(error)")
//            }
//        })
//        return container
//    }()
//    
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch let error as NSError {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//    } 
//}













