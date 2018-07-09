//
//  MediaListViewController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 7/2/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class MediaListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var album: Album? {
        didSet {
            guard let album = album else { return }
            navigationItem.title = album.title
        }
    }
    
    var selectButtonIsTapped = false
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBarController?.tabBar.isHidden = true
        collectionView?.allowsMultipleSelection = true
        
        guard let medias = album?.medias?.array as? [Media] else { return }
        if !medias.isEmpty {
            selectButton.isEnabled = true
            selectButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBAction func addPhotoTapped(_ sender: UIBarButtonItem) {
        
        if selectButtonIsTapped == false {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let takeVideo = UIAlertAction(title: "Take Video", style: .default) { (_) in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeAudio as String]
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let cameraRoll = UIAlertAction(title: "Camera Roll", style: .default) { (_) in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String, kUTTypeAudio as String]
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(takePhoto)
            alert.addAction(takeVideo)
            alert.addAction(cameraRoll)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            selectButtonIsTapped = false
            selectButton.setTitle("Select", for: .normal)
            selectButton.setImage(nil, for: .normal)
            selectButton.isEnabled = true
            selectButton.setTitleColor(UIColor.white, for: .normal)
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "cameraLogo")
            collectionView.reloadData()
            navigationItem.title = album?.title
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if selectButtonIsTapped == false {
            selectButtonIsTapped = true
            selectButton.isEnabled = false
            selectButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
            selectButton.setImage(#imageLiteral(resourceName: "trashCan").withRenderingMode(.alwaysOriginal), for: .normal)
            selectButton.setTitle(nil, for: .normal)
            navigationItem.rightBarButtonItem?.image = nil
            navigationItem.title = "0 Items Selected"
        } else {
            let alert = UIAlertController(title: "Delete selected items?", message: "Are you sure you want to delete selected items? Deleted itmes cannot be recovered.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                
                var mediasToDelete = [Media]()
                let indexPaths = self.collectionView.indexPathsForSelectedItems ?? []
                for indexPath in indexPaths {
                    guard let medias = self.album?.medias, let media = medias[indexPath.item] as? Media else { return }
                    mediasToDelete.append(media)
                }
                
                self.selectButtonIsTapped = false
                self.selectButton.setImage(nil, for: .normal)
                self.selectButton.setTitle("Select", for: .normal)
                self.selectButton.setTitleColor(UIColor.white, for: .normal)
                self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "cameraLogo")
                self.navigationItem.title = self.album?.title
                MediaController.shared.deleteMedia(medias: mediasToDelete)
                self.collectionView.deleteItems(at: indexPaths)
                guard let album = self.album, let medias = album.medias?.array as? [Media] else { return }
                if medias.isEmpty {
                    self.selectButton.isEnabled = false
                    self.selectButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
                }
                self.collectionView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension MediaListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let medias = album?.medias else { return 0 }
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaDetailCell", for: indexPath) as? MediaListCollectionViewCell else { return UICollectionViewCell() }
        if let medias = album?.medias, let media = medias[indexPath.row] as? Media, let imageData = media.image, let image = UIImage(data: imageData) {
            cell.media.image = image
        } else {
            if let medias = album?.medias, let media = medias[indexPath.row] as? Media, let videoURLAsString = media.video {
                
                let url = URL(fileURLWithPath: videoURLAsString)
                
                let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = documentsDirectoryURL[0]
                let destinationURL = fileName.appendingPathComponent(url.lastPathComponent)
                
                let videoImage = MediaController.shared.thumbnailImageForFileURL(destinationURL)
                cell.media.image = videoImage ?? #imageLiteral(resourceName: "noImage")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let medias = album?.medias, let media = medias[indexPath.item] as? Media else { return }
        if selectButtonIsTapped {
            if let selectedItemsCount = collectionView.indexPathsForSelectedItems {
                navigationItem.title = "\(selectedItemsCount.count) Items Selected"
            }
            selectButton.isEnabled = true 
        } else {
            collectionView.reloadData()
            let mediaDetailVC = storyboard?.instantiateViewController(withIdentifier: "MediaPreviewVC") as! MediaPreviewViewController
            mediaDetailVC.media = media
            mediaDetailVC.modalTransitionStyle = .crossDissolve
            present(mediaDetailVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItemsCount = collectionView.indexPathsForSelectedItems {
            navigationItem.title = "\(selectedItemsCount.count) Items Selected"
            if selectedItemsCount.count == 0 {
                selectButton.isEnabled = false 
            }
        }
    }
}

extension MediaListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3 - 5, height: view.frame.width / 3 - 5)
    }
}

extension MediaListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let album = album else { return }
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            MediaController.shared.addImage(album: album, image: editedImage)
            AlbumController.shared.updateAlbumImage(album: album, image: editedImage)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            MediaController.shared.addImage(album: album, image: originalImage)
            AlbumController.shared.updateAlbumImage(album: album, image: originalImage)
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            MediaController.shared.saveVideoWithURL(url: videoURL) { (url) in
                if let url = url {
                    DispatchQueue.main.async {
                        let videoURLAsString = url.absoluteString
                        MediaController.shared.addVideo(album: album, video: videoURLAsString)
                        
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
        selectButton.isEnabled = true
        selectButton.setTitleColor(UIColor.white, for: .normal)
        collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
}





