//
//  PostModel.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postId: String // Id for the post in Database
    var userId: String // Id for the user in database
    var username: String
    var caption: String?
    var dateCreated:Date
    var likeCount: Int
    var likedByUser:Bool
    
    // postId
    // userId
    // user username
    // caption - optional
    // date
    // likes count
    // liked by current user
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
