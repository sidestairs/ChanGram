//
//  BrowseView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct BrowseView: View {
    var post: PostArrayObject
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            CarouselView()
            ImageGridView(posts: post)
        }
        .navigationBarTitle("Browse")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView(post: PostArrayObject(shuffle: true))
        }
    }
}
