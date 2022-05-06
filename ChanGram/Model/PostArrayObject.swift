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
    
    /// Use for single post selection
    init(post:PostModel) {
        self.dataArray.append(post)
    }
    
}
