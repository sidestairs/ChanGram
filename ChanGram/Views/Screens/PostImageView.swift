//
//  PostImageView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import simd

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var captionText:String = ""
    @Binding var imageSelected:UIImage
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserId:String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName:String?
    
    // alert
    @State var showAlert:Bool = false
    @State var uploadPostSuccessfully:Bool = false
    
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
            .alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
            }
        }
    }
    
    // MARK: FUNCTION
    
    func postPicture() {
        print("Post picture to database here")
        guard let userId = currentUserId, let displayName = currentDisplayName else {
            print("error getting user id")
            return
        }
        
        DataService.instance.uploadPost(image: imageSelected, caption: captionText, displayName: displayName, userId: userId) { success in
            self.uploadPostSuccessfully = true
            self.showAlert.toggle()
        }
    }
    
    func getAlert() -> Alert {
        if uploadPostSuccessfully {
            return Alert(title: Text("Successful uploaded post"), message: nil, dismissButton: .default(Text("ok")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        } else {
            return Alert(title:Text("Error uploading post"))
        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        PostImageView(imageSelected: $image)
            .preferredColorScheme(.light)
            
    }
}
