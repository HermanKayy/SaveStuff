//
//  Password+Convenience.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/7/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

extension Password {
    convenience init(title: String, username: String, passcode: String, notes: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.username = username
        self.passcode = passcode
        self.notes = notes
    }
}
