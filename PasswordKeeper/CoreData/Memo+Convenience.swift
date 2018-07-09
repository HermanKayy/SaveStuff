//
//  Memo+Convenience.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/29/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

extension Memo {
    convenience init(title: String, notes: String, color: String = "Gray", context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.color = color
        self.notes = notes
    }
}
