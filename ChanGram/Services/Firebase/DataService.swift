//
//  DataService.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 11/5/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    // MARK: Properties
    
    static let instance = DataService()
    private var REF_POST = DB_BASE.collection("posts")
    
    // MARK: Create Function
    
    func uploadPost(image:UIImage, caption:String?, displayName:String, userId:String, handler:@escaping(_ success:Bool)->()) {
        
        // create new documenmt
        let document = REF_POST.document()
        let postId = document.documentID
        
        // upload image to storage
        ImageManager.instance.uploadPostImage(postId: postId, image: image) { success in
            if success {
                let postData:[String:Any] = [
                    DatabasePostField.postId: postId,
                    DatabasePostField.userId: userId,
                    DatabasePostField.displayName: displayName,
                    DatabasePostField.caption: caption ?? "",
                    DatabasePostField.dateCreated: FieldValue.serverTimestamp()
                ]
                // successfully upload image
                document.setData(postData) { error in
                    if let error = error {
                        print("error \(error)")
                        handler(false)
                        return
                    } else {
                        handler(true)
                        return
                    }
                }
                
            } else {
                print("Error uploading image to firebase")
                handler(false)
                return
            }
        }
        
    }
    
    // MARK: Get Function
    
    func downloadPostForUser(userId:String, handler:@escaping(_ posts:[PostModel])->()) {
        REF_POST.whereField(DatabasePostField.userId, isEqualTo: userId).getDocuments { querySnapshot, error in
            handler(self.getPostFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostForFeed(handler:@escaping(_ posts:[PostModel])->()) {
        REF_POST.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments { querySnapshot, error in
            handler(self.getPostFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostFromSnapshot(querySnapshot:QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                let postId = document.documentID
                
                if
                    let userId = document.get(DatabasePostField.userId) as? String,
                    let displayName = document.get(DatabasePostField.displayName) as? String,
                    let timestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                        let caption = document.get(DatabasePostField.caption) as? String
                        let date = timestamp.dateValue()
                        let newPost = PostModel(postId: postId, userId: userId, username: displayName, caption: caption, dateCreated: date, likeCount: 0, likedByUser: false)
                        postArray.append(newPost)
                }
            }
            return postArray
            
        } else {
            print("no document found in snapshot for this user")
            return postArray
        }
    }
    
}
