//
//  AlbumListTableViewCell.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/10/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class AlbumListTableViewCell: UITableViewCell {
    
    var album: Album? 
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var cellContainerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumImage.layer.borderColor = UIColor.white.cgColor
        albumImage.layer.borderWidth = 1
        cellContainerView.layer.masksToBounds = false
        cellContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellContainerView.layer.shadowRadius = 2
        cellContainerView.layer.shadowColor = UIColor.black.cgColor
        cellContainerView.layer.shadowOpacity = 0.6
        
        setupViews()
    }
    
    func setupViews() {
        guard let album = album, let medias = album.medias?.array as? [Media] else { return }
        albumLabel.text = album.title
        if medias.last?.image != nil {
            if let imageData = album.image, let image = UIImage(data: imageData) {
                albumImage.image = image
            }
        } else {
            if let medias = album.medias, let media = medias.lastObject as? Media, let videoAsString = media.video {
                
                let url = URL(fileURLWithPath: videoAsString)
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = documentsDirectory[0]
                let destinationURL = fileName.appendingPathComponent(url.lastPathComponent)
                let videoThumbnail = MediaController.shared.thumbnailImageForFileURL(destinationURL)
                albumImage.image = videoThumbnail ?? #imageLiteral(resourceName: "noImage")
            }
        }
        
    }
}








