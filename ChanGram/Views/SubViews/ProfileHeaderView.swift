//
//  ProfileHeaderView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var profileDisplayName:String
    @Binding var profileImage:UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            // MARK: Profile Picture
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            // MARK: Username
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // MARK: Bio
            Text("This is the area where they can add bio to their profile")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
            
            HStack(alignment: .center, spacing: 20) {
                
                // MARK: Post
                VStack(alignment: .center, spacing: 5) {
                    Text("5")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                
                // MARK: Likes
                VStack(alignment: .center, spacing: 5) {
                    Text("25")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var name: String = "Joe"
    @State static var profileImage:UIImage = UIImage(named:"dog1")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $profileImage)
            .previewLayout(.sizeThatFits)
    }
}
