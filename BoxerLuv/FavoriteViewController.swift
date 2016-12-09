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

class FavoriteViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "isFavorite = true")
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(10, 0, self.bottomLayoutGuide.length, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack.context
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
