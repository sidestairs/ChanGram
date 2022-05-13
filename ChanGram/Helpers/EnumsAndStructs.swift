//
//  EnumsAndStructs.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 10/5/22.
//

import Foundation

struct DatabaseUserField { // Fields within the User Document in Database
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerId = "provider_id"
    static let provider = "provider"
    static let userId = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
    
}

struct DatabasePostField { // Fields within Post Document in Database
    
    static let postId = "post_id"
    static let userId = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likeCount = "like_count" // Int
    static let likedBy = "liked_by" // array
    static let comments = "comments" // sub-collection
    
}

struct DatabaseCommentsField { // Fields within the Comment SUBcollection of a Post Document
    
    static let commentId = "comment_id"
    static let displayName = "display_name"
    static let userId = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"
    
}

struct DatabaseReportsField { // Fields within Report Document in Database
    
    static let content = "content"
    static let postId = "post_id"
    static let dateCreated = "date_created"
    
}

struct CurrentUserDefaults { // Fields for UserDefaults saved within app
    
    static let displayName = "display_name"
    static let bio = "bio"
    static let userId = "user_id"
    
}

enum SettingsEditTextOption {
    case displayName
    case bio
}
