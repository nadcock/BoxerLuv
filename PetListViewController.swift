//
//  PetListViewController.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/6/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PetListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: self.sharedContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return frc
    }()
    
    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = UIColor.white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(10, 0, self.bottomLayoutGuide.length, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator()
        indicator.startAnimating()
        
        RescueGroupsAPI.sharedInstance().getNewAnimals(){ JSONResult, error  in
            if let error = error {
                displayAlert(alertMessage: error.localizedDescription)
            } else {
                
                if let animalsDictionary = JSONResult!.value(forKey: RescueGroupsAPI.ResponseKeys.data) as? [String : AnyObject] {
                    
                    let _ = animalsDictionary.map() { (key: String, value: AnyObject) -> Dog? in
                        
                        if RescueGroupsAPI().doesAnimalExistInStore(id: key, context: self.sharedContext) {
                            return nil
                        }
                        
                        let dictionary = value as! [String : AnyObject]
                        
                        let dog = Dog(context: self.sharedContext)
                        
                        
                        if let id = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalID] as? String {
                            if let idInt = Int32(id) {
                                dog.id = idInt
                            }
                            else {
                                displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalID)")
                            }
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalID)")
                        }
                        
                        if let name = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalName] as? String {
                            dog.name = name
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalName)")
                        }
                        
                        if let age = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalAgeString] as? String {
                            dog.ageString = age
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalAgeString)")
                        }
                        
                        if let breed = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalBreed] as? String {
                            dog.breed = breed
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalBreed)")
                        }
                        
                        if let sex = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalSex] as? String {
                            dog.sex = sex
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalSex)")
                        }
                        
                        if let color = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalColor] as? String {
                            dog.color = color
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalColor)")
                        }
                        
                        if var animalDesc = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalDescriptionPlain] as? String {
                            if animalDesc == "" {
                                animalDesc = "No description available."
                            } else {
                                animalDesc = animalDesc.stringByDecodingHTMLEntities
                            }
                            dog.animalDescription = animalDesc
                            
                        } else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalDescriptionPlain)")
                        }
                        
                        if let thumbnail = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalThumbnailUrl] as? String {
                            RescueGroupsAPI().downloadPhoto(url: thumbnail, managedObject: dog) { (managedObject: NSManagedObject, photo: NSData) in
                                let dog = managedObject as! Dog
                                dog.thumbnail = photo
                                
                            }} else {
                            displayAlert(alertMessage: "Error saving \(RescueGroupsAPI.ResponseKeys.dataKeys.animalThumbnailUrl)")
                        }
                        
                        if let animalPictures = dictionary[RescueGroupsAPI.ResponseKeys.dataKeys.animalPictures] as?
                            [[String: Any]] {
                            for picture in animalPictures {
                               let _ = picture.map { (key: String, value: Any) -> Photo? in
                                    if key == "large" {
                                        let largePhotoDictionary = value as! [String: Any]
                                        let image = Photo(context: self.sharedContext)
                                        image.urlString = largePhotoDictionary["url"] as? String
                                        image.dog = dog
                                        return image
                                    }
                                    return nil
                                }
                            }
                        }
                        
                        return dog
                    }
                    
                    // Update the table on the main thread
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                } else {
                    let error = NSError(domain: "Cant find data in \(JSONResult!)", code: 0, userInfo: nil)
                    print(JSONResult!.value(forKey: RescueGroupsAPI.ResponseKeys.data)!)
                    print(error)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack.context
    }
    
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PetListCell
        let dog = fetchedResultsController.object(at: indexPath) as! Dog
        
        cell.animalName.text = "\(dog.name!)"
        cell.animalAge.text = "Age: \(dog.ageString!)"
        cell.animalBreed.text = "Breed: \(dog.breed!)"
        cell.animalSex.text = "Sex: \(dog.sex!)"
        cell.animalColor.text = "Color: \(dog.color!)"
        if let thumbnail = dog.thumbnail {
            cell.animalImage.image = UIImage(data: thumbnail as Data)
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewControler") as! DetailViewController
        
        detailViewController.dog = (fetchedResultsController.object(at: indexPath) as! Dog)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.update:
            tableView.cellForRow(at: indexPath!)
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
}
