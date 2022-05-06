//
//  PostImageView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var captionText:String = ""
    @Binding var imageSelected:UIImage
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                }
            .accentColor(.primary)
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                
                TextField("Add your caption here...", text: $captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.beigeColor)
                    .font(.headline)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .autocapitalization(.sentences)
                
                Button {
                    postPicture()
                } label: {
                    Text("Post Picture".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.MyTheme.purpleColor)
                        .font(.headline)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .accentColor(Color.MyTheme.yellowColor)

                
            }
        }
    }
    
    // MARK: FUNCTION
    
    func postPicture() {
        print("Post picture to database here")
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        PostImageView(imageSelected: $image)
            .preferredColorScheme(.light)
            
    }
}
