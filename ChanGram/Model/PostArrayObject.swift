//
//  PostArrayObject.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import Foundation

class PostArrayObject:ObservableObject {
    
    @Published var dataArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    init() {
        print("Test Data")
        
        let post1 = PostModel( postId: "", userId: "", username: "Joe Green", caption: "This is caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
        self.dataArray.append(post1)
    }
    
    /// USED FOR SINGLE POST SELECTION
    init(post:PostModel) {
        self.dataArray.append(post)
    }
    
    /// USED FOR GETTING POST FOR USER PROFILE
    init(userId:String) {
        
        print("GET POSTS FOR USER ID \(userId)")
        
        DataService.instance.downloadPostForUser(userId: userId) { returnedPosts in
            let sortedPost = returnedPosts.sorted { postA, postB in
                return postA.dateCreated > postB.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPost)
        }
    }
    
    /// USED FOR FEED
    init(shuffled:Bool) {
        
        print("GET POSTS FOR FEED. SHUFFLED: \(shuffled)")
        
        DataService.instance.downloadPostForFeed { returnedPosts in
            if shuffled {
                let shuffledPost = returnedPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPost)
            } else {
                self.dataArray.append(contentsOf: returnedPosts)
            }
        }
    }
    
    func updateCounts() {
        
        // post count
        self.postCountString = "\(self.dataArray.count)"
        
        // like count
        let likeCountArray = dataArray.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
        
    }
    
}
