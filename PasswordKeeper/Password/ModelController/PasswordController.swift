//
//  PasswordController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/6/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

class PasswordController {
    
    static let shared = PasswordController()
    var passwords: [Password] {
        
        let moc = CoreDataStack.context
        
        let request: NSFetchRequest<Password> = Password.fetchRequest()
        var passwordsToReturn: [Password]
        do {
            passwordsToReturn = try moc.fetch(request)
        } catch {
            print("Error loading passwords", error)
            passwordsToReturn = []
        }
        return passwordsToReturn
    }
    
    // MARK: CRUD
    func createNewPassword(title: String, username: String, passcode: String, notes: String?) {
        let _ = Password(title: title, username: username, passcode: passcode, notes: notes)
        saveToPersistentStore()
    }
    
    func updatePassword(password: Password, title: String, username: String, passcode: String, notes: String?) {
        password.title = title
        password.username = username
        password.passcode = passcode
        password.notes = notes
        saveToPersistentStore()
    }
    
    func deletePassword(password: Password) {
        password.managedObjectContext?.delete(password)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}







