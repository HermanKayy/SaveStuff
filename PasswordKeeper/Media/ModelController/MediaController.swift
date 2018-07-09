//
//  MediaController.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/11/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit
import AVKit

class MediaController {
    
    static let shared = MediaController()
    
    func addImage(album: Album, image: UIImage) {
        guard let convertedImage = UIImageJPEGRepresentation(image, 0.3) else { return }
        let _ = Media(album: album, image: convertedImage, video: nil)
        PasswordController.shared.saveToPersistentStore()
    }
    
    func addVideo(album: Album, video: String) {
        let _ = Media(album: album, image: nil, video: video)
        PasswordController.shared.saveToPersistentStore()
    }
    
    func deleteMedia(medias: [Media]) {
        
        for media in medias {
            media.managedObjectContext?.delete(media)
            if let videoString = media.video {
                deleteVideo(videoURLAsString: videoString)
            }
        }
        PasswordController.shared.saveToPersistentStore()
    }
    
    // MARK: Save Video to FileManager
    func saveVideoWithURL(url: URL, completion: @escaping(URL?) -> Void) {
        let documentsDirectory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = documentsDirectory[0]
        let destinationURL = fileName.appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            print("File Path Already Exists")
            
        } else {
            
            URLSession.shared.downloadTask(with: url) { (url, response, error) in
                if let error = error {
                    print("❌ Error downloading task", error)
                    completion(nil); return
                }
                
                if let url = url {
                    do {
                        try FileManager.default.moveItem(at: url, to: destinationURL)
                        completion(destinationURL); return
                    } catch {
                        print("Error with url", error)
                        completion(nil); return 
                    }
                }
            }.resume()
        }
    }
    
    // MARK: Delete Video from File Manager
    func deleteVideo(videoURLAsString: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = documentsDirectory[0]
        guard let baseURL = URL(string: videoURLAsString) else { return }
        let url = fileName.appendingPathComponent(baseURL.lastPathComponent)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: fileName, includingPropertiesForKeys: nil, options: [])
            print("DirectoryContentsAmount", directoryContents.count)
            do {
                for file in directoryContents {
                    if url == fileName.appendingPathComponent(file.lastPathComponent) {
                        try FileManager.default.removeItem(at: file)
                        print("Successfully deleted video at:", file)
                    }
                }
            } catch {
                print("Can't delete video", error)
            }
        } catch {
            print("Can't access directoryContents", error)
        }
    }
    
    // MARK: Thumbnail for Video
    func thumbnailImageForFileURL(_ fileURL: URL) -> UIImage? {
        let asset = AVAsset(url: fileURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print("Error saving asset as thumbnail", error)
        }
        return nil
    }
    
}





