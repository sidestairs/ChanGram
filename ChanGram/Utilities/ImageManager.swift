//
//  ImageManager.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 10/5/22.
//

import Foundation
import FirebaseStorage
import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class ImageManager {
    
    // MARK: properties
    
    static let instance = ImageManager()
    
    private var REF_STOR = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
    
    func uploadProfileImage(userId:String, image:UIImage) {
        // Get the path where we will save the image
        let path = getProfileImagePath(userId: userId)
        
        // Save image to path
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { _ in }
        }
    }
    
    func uploadPostImage(postId:String, image:UIImage, handler:@escaping(_ success:Bool)->()) {
        // Get the path to save the images
        let path = getPostImagePath(postId: postId)
        
        // save image to path
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { success in
                DispatchQueue.main.async {
                    handler(success)
                }
            }
        }
    }
    
    func downloadProfileImage(userId: String, handler: @escaping(_ image:UIImage?)->()) {
        // get the path where the image is saved
        let path = getProfileImagePath(userId: userId)
        
        // Download the image from path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { returnedImage in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    func downloadPostImage(postId: String, handler: @escaping(_ image:UIImage?)->()) {
        let path = getPostImagePath(postId: postId)
        
        // Download post images
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { returnedImage in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    private func getProfileImagePath(userId:String) -> StorageReference {
        let userPath = "users/\(userId)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        
        return storagePath
    }
    
    private func getPostImagePath(postId:String) -> StorageReference {
        let postPath = "posts/\(postId)/1"
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath
    }
    
    private func uploadImage(path:StorageReference, image:UIImage, handler: @escaping(_ success:Bool)->()) {
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 240 * 240 // Max file size
        let maxCompression: CGFloat = 0.05
        
        // original data
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // check max file size
        while (originalData.count > maxFileSize) && compression>maxCompression {
            compression -= 0.05
            if let compressData = image.jpegData(compressionQuality: compression) {
                originalData = compressData
            }
        }
        
        // final data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        path.putData(finalData, metadata: metadata) { (_, error) in
            if let error = error {
                print("Error uploading image \(error)")
                handler(false)
                return
            } else {
                print("Success uploading image")
                handler(true)
                return
            }
        }
    }
    
    private func downloadImage(path: StorageReference, handler: @escaping(_ image:UIImage?)->()) {
        
        if let cacheImage = imageCache.object(forKey: path) {
            print("image found in cache")
            handler(cacheImage)
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { returnedImageData, error in
                if let data = returnedImageData, let image = UIImage(data: data) {
                    // success getting image data
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    print("error getting data from path for image")
                    handler(nil)
                    return
                }
            }
        }
    }
}
