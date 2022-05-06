//
//  SettingEditImageView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct SettingEditImageView: View {
    @State var title: String
    @State var description: String
    @State var selectedImage:UIImage // image shown on screen
    
    @State var sourceType:UIImagePickerController.SourceType = .photoLibrary
    @State var showImagePicker: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            Image("dog1")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
            Button {
                showImagePicker.toggle()
            } label: {
                Text("Import")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.purpleColor)
            
            Button {
                
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            }
            .accentColor(Color.MyTheme.yellowColor)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
            }

            Spacer()
            
        }
        .padding()
        .frame(maxWidth:.infinity)
        .navigationTitle(title)
    }
}

struct SettingEditImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingEditImageView(title: "Title", description: "Description", selectedImage: UIImage(named: "dog1")!)
        }
    }
}
