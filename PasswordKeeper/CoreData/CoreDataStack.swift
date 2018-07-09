//
//  CoreDataStack.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/6/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PasswordKeeper")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                print("❌ Error loading from Core Data", error)
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}

