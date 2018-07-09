//
//  MediaPreviewViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AVKit

class MediaPreviewViewController: UIViewController {
    
    var media: Media?
    var playerVC = AVPlayerViewController()
    var player: AVPlayer? 

    @IBOutlet weak var mediaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTouched))
        mediaImage.addGestureRecognizer(tapGesture)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenTouched))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenTouched))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenTouched))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenTouched))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        playerVC.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        if let imageData = media?.image {
            mediaImage.isHidden = false
            let image = UIImage(data: imageData)
            mediaImage.image = image
        } else if let videoURLAsString = media?.video {
            mediaImage.isHidden = true
            let url = URL(fileURLWithPath: videoURLAsString)
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileName = documentsDirectoryURL[0]
            let destinationURL = fileName.appendingPathComponent(url.lastPathComponent)
            
            player = AVPlayer(url: destinationURL)
            playerVC.player = player
            playerVC.view.frame = view.bounds
            view.addSubview(playerVC.view)
            
            present(playerVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func screenTouched() {
        dismiss(animated: true, completion: nil)
    }
}
