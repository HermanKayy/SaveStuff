//
//  MediaListCollectionViewCell.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class MediaListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var media: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        media.image = nil 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        isUserInteractionEnabled = true
    }
    
    override var isSelected: Bool {
        didSet {
            checkMark.isHidden = isSelected ? false : true
            layer.opacity = isSelected ? 0.5 : 1
        }
    }
}





