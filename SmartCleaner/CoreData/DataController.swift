//
//  Persistence.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 13.06.2022.
//

import Foundation
import CoreData

import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "PhotoModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
}
