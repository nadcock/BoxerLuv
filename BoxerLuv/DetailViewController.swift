//
//  DetailViewController.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/8/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import CoreData

class DetailViewController: UIViewController {
    

    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet var animalName: UILabel!
    @IBOutlet var animalAge: UILabel!
    @IBOutlet var animalBreed: UILabel!
    @IBOutlet var animalDescription: UILabel!
    @IBOutlet var animalColor: UILabel!
    @IBOutlet var animalSex: UILabel!
    @IBOutlet var favoriteButton: DOFavoriteButton!
    
    var dog: Dog?
    var inFullScreenView = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        inFullScreenView = false
        
        if let dog = dog {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            animalName.text = dog.name
            animalAge.text = "Age:\n  \(dog.ageString!)"
            animalBreed.text = "Breed:\n  \(dog.breed!)"
            animalDescription.text = "Description: \(dog.animalDescription!)"
            animalColor.text = "Color:\n  \(dog.color!)"
            animalSex.text = "Sex:\n  \(dog.sex!)"
            
            if dog.isFavorite == true {
                favoriteButton.select()
            }
            
            let photoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            let predicate = NSPredicate(format: "dog = %@", dog)
            photoFetch.predicate = predicate
            var fetchedPhotos: [Photo] = []
            
            do {
                fetchedPhotos = try sharedContext.fetch(photoFetch) as! [Photo]
            } catch {
                displayAlert(alertMessage: "Unable to fetch photos from store")
            }
            
            var imageSources: [SDWebImageSource] = []
            
            if fetchedPhotos.count > 0 {
                for photo in fetchedPhotos {
                    imageSources.append(SDWebImageSource(url: URL(string: photo.urlString!)!, placeholder: #imageLiteral(resourceName: "dog-paw24.png")))
                }
            }
            
            
            slideshow.circular = true
            slideshow.setImageInputs(imageSources)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTap))
            slideshow.addGestureRecognizer(recognizer)
            favoriteButton.addTarget(self, action: #selector(DetailViewController.favTapped), for: .touchUpInside)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !inFullScreenView {
            navigationController?.popViewController(animated: false)
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack.context
    }
    
    @objc func didTap() {
        inFullScreenView = true
        slideshow.presentFullScreenController(from: self)
    }
    
    @objc func favTapped(sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            if let dog = dog {
                dog.isFavorite = false
                sender.deselect()
            }
            
        } else {
            // select with animation
            if let dog = dog {
                dog.isFavorite = true
                sender.select()
            }
        }
    }
}
