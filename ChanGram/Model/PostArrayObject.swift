//
//  PostArrayObject.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import Foundation

class PostArrayObject:ObservableObject {
    
    @Published var dataArray = [PostModel]()
    
    init() {
        print("FETCH FROM DATABASE")
        
        let post1 = PostModel( postId: "", userId: "", username: "Joe Green", caption: "This is caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post2 = PostModel( postId: "", userId: "", username: "Jessica", caption: "This second caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post3 = PostModel( postId: "", userId: "", username: "Thomas", caption: "This is a really long long long caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post4 = PostModel( postId: "", userId: "", username: "Christopher", caption: nil, dateCreated: Date(), likeCount: 0, likedByUser: false)
        
        self.dataArray.append(post1)
        self.dataArray.append(post2)
        self.dataArray.append(post3)
        self.dataArray.append(post4)
    }
    
    /// USED FOR SINGLE POST SELECTION
    init(post:PostModel) {
        self.dataArray.append(post)
    }
    
    /// USED FOR GETTING POST FOR USER PROFILE
    init(userId:String) {
        
        print("get post from user id \(userId)")
        
        DataService.instance.downloadPostForUser(userId: userId) { returnedPosts in
            let sortedPost = returnedPosts.sorted { postA, postB in
                return postA.dateCreated > postB.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPost)
        }
    }
    
    /// USED FOR FEED
    init(shuffle:Bool) {
        
        print("getting all feed post")
        
        DataService.instance.downloadPostForFeed { returnedPosts in
            if shuffle {
                let shuffledPost = returnedPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPost)
            } else {
                self.dataArray.append(contentsOf: returnedPosts)
            }
        }
    }
    
}
