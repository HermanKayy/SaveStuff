//
//  Media+Convenience.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import Foundation
import CoreData

extension Media {
    
    convenience init(album: Album, image: Data?, video: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.album = album
        self.image = image
        self.video = video
    }
}
