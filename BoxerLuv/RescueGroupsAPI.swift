//
//  RescueGroupsAPI.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/6/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation
import CoreData

class RescueGroupsAPI: NSObject {
    
    typealias CompletionHander = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    var session: URLSession
    
    
    let jsonBody = [
        PostKeys.apiKey : PostValues.apiKey,
        PostKeys.objectType : PostValues.objectType,
        PostKeys.objectAction : PostValues.objectAction,
        PostKeys.search : [
            PostKeys.SearchKeys.resultStart : PostValues.SearchValues.resultStart,
            PostKeys.SearchKeys.resultLimit : PostValues.SearchValues.resultLimit,
            PostKeys.SearchKeys.resultSort : PostValues.SearchValues.resultSort,
            PostKeys.SearchKeys.resultOrder : PostValues.SearchValues.resultOrder,
            PostKeys.SearchKeys.filters : [
                [
                    PostKeys.SearchKeys.FilterKeys.fieldName : PostValues.SearchValues.FilterValues.fieldName,
                    PostKeys.SearchKeys.FilterKeys.operation : PostValues.SearchValues.FilterValues.operation,
                    PostKeys.SearchKeys.FilterKeys.criteria : PostValues.SearchValues.FilterValues.criteria
                ]
            ],
            PostKeys.SearchKeys.filterProcessing : PostValues.SearchValues.filterProcessing,
            PostKeys.SearchKeys.fields : PostValues.SearchValues.fields
        ]
    ] as [String : Any]
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    func getNewAnimals(completionHandler: @escaping CompletionHander) {
        var request = URLRequest(url: URL(string: Constants.BaseUrl)!)
        request.httpMethod = "Post"
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: [])
        
        
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            
            if let error = downloadError {
                displayAlert(alertMessage: error.localizedDescription)
            } else {
                RescueGroupsAPI.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        })
        
        task.resume()
        
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> RescueGroupsAPI {
        
        struct Singleton {
            static var sharedInstance = RescueGroupsAPI()
        }
        
        return Singleton.sharedInstance
    }
    
    class func parseJSONWithCompletionHandler(_ data: Data, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: Any?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(nil, error)
        } else {
            completionHandler(parsedResult as AnyObject?, nil)
        }
    }
    
    func downloadPhoto(url: String, managedObject: NSManagedObject, handler: (NSManagedObject, NSData) -> Void) {
        let imageURL = URL(string: url)
        
        if let imageData = NSData(contentsOf: imageURL!) {
            handler(managedObject, imageData)
        } else {
            displayAlert(alertMessage: "Image does not exist at \(imageURL)")
        }
    }
    
    func doesAnimalExistInStore(id: String, context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        let predicate = NSPredicate(format: "id = %@", id)
        request.predicate = predicate
        request.sortDescriptors = []
        
        do {
            let count = try context.count(for: request)
            
            if count < 1 {
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
}

