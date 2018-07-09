//
//  AlbumController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/10/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import CoreData

class AlbumController {
    
    static let shared = AlbumController()
    var albums: [Album] {
        
        let moc = CoreDataStack.context
        
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        var albumsToReturn: [Album]
        do {
            albumsToReturn = try moc.fetch(request)
        } catch {
            print("❌ Error loading albums", error)
            albumsToReturn = []
        }
        return albumsToReturn
    }
    
    // MARK: CRUD
    func addAlbum(title: String, image: UIImage) {
        guard let convertedImage = UIImageJPEGRepresentation(image, 0.3) else { return }
        let _ = Album(title: title, image: convertedImage)
        PasswordController.shared.saveToPersistentStore()
    }
    
    func updateAlbumImage(album: Album, image: UIImage) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.3) else { return }
        album.image = imageData
        PasswordController.shared.saveToPersistentStore()
    }
    
    func deleteAlbum(album: Album) {
        album.managedObjectContext?.delete(album)
        PasswordController.shared.saveToPersistentStore()
    }
}








