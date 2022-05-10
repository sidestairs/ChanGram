//
//  ImageManager.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 10/5/22.
//

import Foundation
import FirebaseStorage
import UIKit

class ImageManager {
    
    // MARK: properties
    
    static let instance = ImageManager()
    
    private var REF_STOR = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
    
    func uploadProfileImage(userId:String, image:UIImage) {
        // Get the path where we will save the image
        let path = getProfileImagePath(userId: userId)
        
        // Save image to path
        uploadImage(path: path, image: image) { _ in }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    private func getProfileImagePath(userId:String) -> StorageReference {
        let userPath = "users/\(userId)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        
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
}
