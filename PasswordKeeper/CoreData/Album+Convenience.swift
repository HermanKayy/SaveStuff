//
//  Album+Convenience.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

extension Album {
    convenience init(title: String, image: Data, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.image = image
    }
}
