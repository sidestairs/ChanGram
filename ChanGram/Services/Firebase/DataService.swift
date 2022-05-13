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
    
    private var REF_POSTS = DB_BASE.collection("posts")
    private var REF_REPORTS = DB_BASE.collection("reports")
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    
    // MARK: Create Function
    
    func uploadPost(image:UIImage, caption:String?, displayName:String, userId:String, handler:@escaping(_ success:Bool)->()) {
        
        // create new documenmt
        let document = REF_POSTS.document()
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
    
    func uploadReport(reason: String, postId: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            DatabaseReportsField.content : reason,
            DatabaseReportsField.postId : postId,
            DatabaseReportsField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        REF_REPORTS.addDocument(data: data) { (error) in
            if let error = error {
                print("Error uploading report. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    
    func uploadComment(postId: String, content: String, displayName: String, userId: String, handler: @escaping (_ success: Bool, _ commentId: String?) -> ()) {
        
        let document = REF_POSTS.document(postId).collection(DatabasePostField.comments).document()
        let commentId = document.documentID
        
        let data: [String:Any] = [
            DatabaseCommentsField.commentId : commentId,
            DatabaseCommentsField.userId : userId,
            DatabaseCommentsField.content : content,
            DatabaseCommentsField.displayName : displayName,
            DatabaseCommentsField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        document.setData(data) { (error) in
            if let error = error {
                print("Error uploading comment. \(error)")
                handler(false, nil)
                return
            } else {
                handler(true, commentId)
                return
            }
        }
        
    }
    
    // MARK: Get Function
    
    func downloadPostForUser(userId:String, handler:@escaping(_ posts:[PostModel])->()) {
        REF_POSTS.whereField(DatabasePostField.userId, isEqualTo: userId).getDocuments { querySnapshot, error in
            handler(self.getPostFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostForFeed(handler:@escaping(_ posts:[PostModel])->()) {
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments { querySnapshot, error in
            handler(self.getPostFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostFromSnapshot(querySnapshot:QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if
                    let userId = document.get(DatabasePostField.userId) as? String,
                    let displayName = document.get(DatabasePostField.displayName) as? String,
                    let timestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date = timestamp.dateValue()
                    
                    let postId = document.documentID
                    
                    let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0
                    
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userID = currentUserID {
                        likedByUser = userIDArray.contains(userID)
                    }
                    
                    let newPost = PostModel(postId: postId, userId: userId, username: displayName, caption: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                        postArray.append(newPost)
                }
            }
            return postArray
            
        } else {
            print("no document found in snapshot for this user")
            return postArray
        }
    }
    
    func downloadComments(postId: String, handler: @escaping (_ comments: [CommentModel]) -> ()) {
        REF_POSTS.document(postId).collection(DatabasePostField.comments).order(by: DatabaseCommentsField.dateCreated, descending: false).getDocuments { (querySnapshot, error) in
            handler(self.getCommentsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if
                    let userId = document.get(DatabaseCommentsField.userId) as? String,
                    let displayName = document.get(DatabaseCommentsField.displayName) as? String,
                    let content = document.get(DatabaseCommentsField.content) as? String,
                    let timestamp = document.get(DatabaseCommentsField.dateCreated) as? Timestamp {
                    
                    let date = timestamp.dateValue()
                    let commentId = document.documentID
                    let newComment = CommentModel(commentId: commentId, userId: userId, username: displayName, content: content, dateCreated: date)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("No comments in document for this post")
            return commentArray
        }
    }
    
    
    // MARK: Update Function
    
    func likePost(postId: String, currentUserId: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayUnion([currentUserId])
        ]
        
        REF_POSTS.document(postId).updateData(data)
    }
    
    func unlikePost(postId: String, currentUserId: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = -1
        let data: [String:Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayRemove([currentUserId])
        ]
        
        REF_POSTS.document(postId).updateData(data)
    }
    
    
    func updateDisplayNameOnPosts(userId: String, displayName: String) {
        
        downloadPostForUser(userId: userId) { (returnedPosts) in
            for post in returnedPosts {
                self.updatePostDisplayName(postId: post.postId, displayName: displayName)
            }
        }
        
    }
    
    private func updatePostDisplayName(postId: String, displayName: String) {
        
        let data: [String:Any] = [
            DatabasePostField.displayName : displayName
        ]
        
        REF_POSTS.document(postId).updateData(data)
    }
}
