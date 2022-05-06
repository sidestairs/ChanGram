//
//  UploadView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import UIKit

struct UploadView: View {
    @State var showImagePicker:Bool = false
    @State var imageSelected: UIImage = UIImage(named:"logo")!
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var showPostImageView:Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                Button {
                    sourceType = UIImagePickerController.SourceType.camera
                    showImagePicker.toggle()
                    
                } label: {
                    Text("Take Photo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.yellowColor)
                }
                .frame( maxWidth: .infinity,  maxHeight: .infinity, alignment: .center)
                .background(Color.MyTheme.purpleColor)
                
                Button {
                    sourceType = UIImagePickerController.SourceType.photoLibrary
                    showImagePicker.toggle()
                } label: {
                    Text("Import Photo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.purpleColor)
                }
                .frame( maxWidth: .infinity,  maxHeight: .infinity, alignment: .center)
                .background(Color.MyTheme.yellowColor)
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                segueToPostImageView()
            }) {
                ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
            }
            
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
                .fullScreenCover(isPresented: $showPostImageView) {
                    PostImageView(imageSelected: $imageSelected)
                }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: FUNCTION
    
    func segueToPostImageView() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            showPostImageView.toggle()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
