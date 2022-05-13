//
//  CommentModel.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import Foundation
import SwiftUI


struct CommentModel: Identifiable, Hashable {
    
    var id = UUID()
    var commentId:String // ID from the database
    var userId:String // ID for the user in the database
    var username: String // username for the user in database
    var content:String // Actual comment text
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
