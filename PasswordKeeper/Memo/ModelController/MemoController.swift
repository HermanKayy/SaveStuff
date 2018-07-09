//
//  MemoController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/29/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

class MemoController {
    
    static let shared = MemoController()
    var memos: [Memo] {
        
        let moc = CoreDataStack.context
        
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        var memosToReturn: [Memo]
        do {
            memosToReturn = try moc.fetch(request)
        } catch {
            print("Error loading memos", error)
            memosToReturn = []
        }
        return memosToReturn
    }
    
    // MARK: CRUD
    func createNewMemo(title: String, notes: String, color: String = "White") {
        let _ = Memo(title: title, notes: notes, color: color)
        saveToPersistentStore()
    }
    
    func updateMemo(memo: Memo, title: String, notes: String, color: String) {
        memo.title = title
        memo.notes = notes
        memo.color = color
        saveToPersistentStore()
    }
    
    func deleteMemo(memo: Memo) {
        memo.managedObjectContext?.delete(memo)
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









