//
//  RescueGroupsAPI-Constants.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/6/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation

extension RescueGroupsAPI {
    
    struct Constants {
        static let BaseUrl = "https://api.rescuegroups.org/http/"
    }
    
    struct PostKeys {
        static let apiKey = "apikey"
        static let objectType = "objectType"
        static let objectAction = "objectAction"
        static let search = "search"
        
        struct SearchKeys {
            static let resultStart = "resultStart"
            static let resultLimit = "resultLimit"
            static let resultSort = "resultSort"
            static let resultOrder = "resultOrder"
            static let filters = "filters"
            static let filterProcessing = "filterProcessing"
            static let fields = "fields"
            struct FilterKeys {
                static let fieldName = "fieldName"
                static let operation = "operation"
                static let criteria = "criteria"
            }
        }
    }
    
    struct PostValues {
        static let apiKey = "cTcSYwbi"
        static let objectType = "animals"
        static let objectAction = "publicSearch"
        
        struct SearchValues {
            static let resultStart = "0"
            static let resultLimit = "100"
            static let resultSort = "animalID"
            static let resultOrder = "asc"
            static let filterProcessing = "1"
            
            struct FilterValues {
                static let fieldName = "animalStatus"
                static let operation = "equals"
                static let criteria = "Available"
            }
            
            static let fields = [
                "animalID",
                "animalOrgID",
                "animalActivityLevel",
                "animalAgeString",
                "animalAltered",
                "animalBirthdate",
                "animalBirthdateExact",
                "animalBreed",
                "animalCoatLength",
                "animalColor",
                "animalColorID",
                "animalDescriptionPlain",
                "animalEarType",
                "animalEnergyLevel",
                "animalExerciseNeeds",
                "animalGeneralAge",
                "animalGeneralSizePotential",
                "animalGroomingNeeds",
                "animalHousetrained",
                "animalIndoorOutdoor",
                "animalLocation",
                "animalLocationCoordinates",
                "animalLocationCitystate",
                "animalMicrochipped",
                "animalMixedBreed",
                "animalName",
                "animalSpecialneeds",
                "animalSpecialneedsDescription",
                "animalNewPeople",
                "animalNotHousetrainedReason",
                "animalObedienceTraining",
                "animalOKWithAdults",
                "animalOKWithCats",
                "animalOKWithDogs",
                "animalOKWithKids",
                "animalOwnerExperience",
                "animalAdoptionPending",
                "animalPrimaryBreed",
                "animalPrimaryBreedID",
                "animalSex",
                "animalSizeCurrent",
                "animalSizeUOM",
                "animalSpecies",
                "animalStatus",
                "animalTailType",
                "animalThumbnailUrl",
                "animalUptodate",
                "animalUpdatedDate",
                "animalVocal",
                "animalYardRequired",
                "animalAffectionate",
                "animalApartment",
                "animalCratetrained",
                "animalDrools",
                "animalEagerToPlease",
                "animalEscapes",
                "animalEventempered",
                "animalFetches",
                "animalGentle",
                "animalGoodInCar",
                "animalGoofy",
                "animalHasAllergies",
                "animalHearingImpaired",
                "animalHypoallergenic",
                "animalIndependent",
                "animalIntelligent",
                "animalLap",
                "animalLeashtrained",
                "animalNeedsCompanionAnimal",
                "animalNoCold",
                "animalNoFemaleDogs",
                "animalNoHeat",
                "animalNoLargeDogs",
                "animalNoMaleDogs",
                "animalNoSmallDogs",
                "animalObedient",
                "animalOKForSeniors",
                "animalOKWithFarmAnimals",
                "animalOlderKidsOnly",
                "animalOngoingMedical",
                "animalPlayful",
                "animalPlaysToys",
                "animalPredatory",
                "animalProtective",
                "animalSightImpaired",
                "animalSkittish",
                "animalSpecialDiet",
                "animalSwims",
                "animalTimid",
                "animalPictures"
            ]
        }
    }
    
    struct ResponseKeys {
        static let status = "status"
        static let foundRows = "foundRows"
        static let data = "data"
        
        struct dataKeys {
            static let animalID                         = "animalID"
            static let animalOrgID                      = "animalOrgID"
            static let animalActivityLevel              = "animalActivityLevel"
            static let animalAgeString                  = "animalAgeString"
            static let animalAltered                    = "animalAltered"
            static let animalBirthdate                  = "animalBirthdate"
            static let animalBirthdateExact             = "animalBirthdateExact"
            static let animalBreed                      = "animalBreed"
            static let animalCoatLength                 = "animalCoatLength"
            static let animalColor                      = "animalColor"
            static let animalColorID                    = "animalColorID"
            static let animalDescriptionPlain           = "animalDescriptionPlain"
            static let animalEarType                    = "animalEarType"
            static let animalEnergyLevel                = "animalEnergyLevel"
            static let animalExerciseNeeds              = "animalExerciseNeeds"
            static let animalGeneralAge                 = "animalGeneralAge"
            static let animalGeneralSizePotential       = "animalGeneralSizePotential"
            static let animalGroomingNeeds              = "animalGroomingNeeds"
            static let animalHousetrained               = "animalHousetrained"
            static let animalIndoorOutdoor              = "animalIndoorOutdoor"
            static let animalLocation                   = "animalLocation"
            static let animalLocationCoordinates        = "animalLocationCoordinates"
            static let animalLocationCitystate          = "animalLocationCitystate"
            static let animalMicrochipped               = "animalMicrochipped"
            static let animalMixedBreed                 = "animalMixedBreed"
            static let animalName                       = "animalName"
            static let animalSpecialneeds               = "animalSpecialneeds"
            static let animalSpecialneedsDescription    = "animalSpecialneedsDescription"
            static let animalNewPeople                  = "animalNewPeople"
            static let animalNotHousetrainedReason      = "animalNotHousetrainedReason"
            static let animalObedienceTraining          = "animalObedienceTraining"
            static let animalOKWithAdults               = "animalOKWithAdults"
            static let animalOKWithCats                 = "animalOKWithCats"
            static let animalOKWithDogs                 = "animalOKWithDogs"
            static let animalOKWithKids                 = "animalOKWithKids"
            static let animalOwnerExperience            = "animalOwnerExperience"
            static let animalAdoptionPending            = "animalAdoptionPending"
            static let animalPrimaryBreed               = "animalPrimaryBreed"
            static let animalPrimaryBreedID             = "animalPrimaryBreedID"
            static let animalSex                        = "animalSex"
            static let animalSizeCurrent                = "animalSizeCurrent"
            static let animalSizeUOM                    = "animalSizeUOM"
            static let animalSpecies                    = "animalSpecies"
            static let animalStatus                     = "animalStatus"
            static let animalTailType                   = "animalTailType"
            static let animalThumbnailUrl               = "animalThumbnailUrl"
            static let animalUptodate                   = "animalUptodate"
            static let animalUpdatedDate                = "animalUpdatedDate"
            static let animalVocal                      = "animalVocal"
            static let animalYardRequired               = "animalYardRequired"
            static let animalAffectionate               = "animalAffectionate"
            static let animalApartment                  = "animalApartment"
            static let animalCratetrained               = "animalCratetrained"
            static let animalDrools                     = "animalDrools"
            static let animalEagerToPlease              = "animalEagerToPlease"
            static let animalEscapes                    = "animalEscapes"
            static let animalEventempered               = "animalEventempered"
            static let animalFetches                    = "animalFetches"
            static let animalGentle                     = "animalGentle"
            static let animalGoodInCar                  = "animalGoodInCar"
            static let animalGoofy                      = "animalGoofy"
            static let animalHasAllergies               = "animalHasAllergies"
            static let animalHearingImpaired            = "animalHearingImpaired"
            static let animalHypoallergenic             = "animalHypoallergenic"
            static let animalIndependent                = "animalIndependent"
            static let animalIntelligent                = "animalIntelligent"
            static let animalLap                        = "animalLap"
            static let animalLeashtrained               = "animalLeashtrained"
            static let animalNeedsCompanionAnimal       = "animalNeedsCompanionAnimal"
            static let animalNoCold                     = "animalNoCold"
            static let animalNoFemaleDogs               = "animalNoFemaleDogs"
            static let animalNoHeat                     = "animalNoHeat"
            static let animalNoLargeDogs                = "animalNoLargeDogs"
            static let animalNoMaleDogs                 = "animalNoMaleDogs"
            static let animalNoSmallDogs                = "animalNoSmallDogs"
            static let animalObedient                   = "animalObedient"
            static let animalOKForSeniors               = "animalOKForSeniors"
            static let animalOKWithFarmAnimals          = "animalOKWithFarmAnimals"
            static let animalOlderKidsOnly              = "animalOlderKidsOnly"
            static let animalOngoingMedical             = "animalOngoingMedical"
            static let animalPlayful                    = "animalPlayful"
            static let animalPlaysToys                  = "animalPlaysToys"
            static let animalPredatory                  = "animalPredatory"
            static let animalProtective                 = "animalProtective"
            static let animalSightImpaired              = "animalSightImpaired"
            static let animalSkittish                   = "animalSkittish"
            static let animalSpecialDiet                = "animalSpecialDiet"
            static let animalSwims                      = "animalSwims"
            static let animalTimid                      = "animalTimid"
            static let animalPictures                   = "animalPictures"
        }
    }
    
}
