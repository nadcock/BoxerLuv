//
//  Dog+CoreDataProperties.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/6/16.
//  Copyright © 2016 NEA. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog");
    }

    @NSManaged public var activityLevel: String?
    @NSManaged public var ageString: String?
    @NSManaged public var altered: Bool
    @NSManaged public var birthdate: NSDate?
    @NSManaged public var birthdateExact: Bool
    @NSManaged public var breed: String?
    @NSManaged public var cityState: String?
    @NSManaged public var coatLength: String?
    @NSManaged public var color: String?
    @NSManaged public var earType: String?
    @NSManaged public var energyLevel: String?
    @NSManaged public var exerciseNeeds: String?
    @NSManaged public var generalAge: String?
    @NSManaged public var groomingNeeds: String?
    @NSManaged public var housetrained: Bool
    @NSManaged public var id: Int16
    @NSManaged public var indoorOutdoor: String?
    @NSManaged public var locationLat: Double
    @NSManaged public var locationLong: Double
    @NSManaged public var locationZip: Int16
    @NSManaged public var microchipped: Bool
    @NSManaged public var mixedBreed: Bool
    @NSManaged public var name: String?
    @NSManaged public var newPeople: String?
    @NSManaged public var sizePotential: String?
    @NSManaged public var specialNeeds: Bool
    @NSManaged public var specialNeedsDescription: String?
    @NSManaged public var summary: String?
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension Dog {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Image)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Image)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}
