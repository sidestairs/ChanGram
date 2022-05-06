//
//  PostView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct PostView: View {
    
    @State var post:PostModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // MARK: HEADER
            HStack {
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(15)
                
                Text(post.username)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.headline)
            }
            .padding(.all, 6)
            
            // MARK: IMAGE
            Image("dog1")
                .resizable()
                .scaledToFit()
            
            //MARK: FOOTER
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "heart")
                    .font(.title3)
                
                // MARK: Comment Icon
                NavigationLink(destination: CommentsView()) {
                    Image(systemName: "bubble.middle.bottom")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Image(systemName: "paperplane")
                    .font(.title3)
                
                Spacer()
            }
            .padding(.all, 6)
            
            if let caption = post.caption {
                HStack {
                    Text(caption)
                    Spacer(minLength: 0)
                }.padding(.all, 6)
            }
            
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var post:PostModel = PostModel(postId: "", userId: "", username: "Paul Smith", caption: "This is a test caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post:post)
            .previewLayout(.sizeThatFits)
    }
}
