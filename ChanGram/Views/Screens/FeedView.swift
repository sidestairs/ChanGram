//
//  FeedView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var posts:PostArrayObject
    @State var title:String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(posts.dataArray, id:\.self) { post in
                    PostView(post: post, showHeaderAndFooter: true)
                }
            }
            
        }
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView(posts:PostArrayObject(), title: "Feed Test")
        }
    }
}
