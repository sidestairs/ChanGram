//
//  ProfileView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct ProfileView: View {
    
    var isMyProfile: Bool
    @State var profileDisplayName: String
    var profileUserId : String
    
    var posts = PostArrayObject()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName)
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            
        }, label: {
            Image(systemName: "line.horizontal.3")
                .accentColor(Color.MyTheme.purpleColor)
                .opacity(isMyProfile ? 1.0 : 0.0)
        }))
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileDisplayName: "joe", profileUserId: "")
        }
    }
}
