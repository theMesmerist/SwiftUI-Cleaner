//
//  Photo+CoreDataProperties.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 13.06.2022.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageD: Data?

}

extension Photo : Identifiable {

}
