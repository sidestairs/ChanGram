//
//  OnboardingViewPart2.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import GoogleSignIn

struct OnboardingViewPart2: View {
    @State var displayName: String = ""
    @State var showImagePicker: Bool = false
    
    // Image picker
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private let user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            Text("What is your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name here....", text:$displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth:.infinity)
                .background(Color.MyTheme.beigeColor)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button {
                showImagePicker.toggle()
            } label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .frame(height: 60)
                    .frame(maxWidth:.infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
            }
            .accentColor(Color.MyTheme.purpleColor)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0), value: displayName)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker) {
            createProfile()
        } content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        }
    }
    
    // MARK: FUNCTION
    
    func createProfile() {
        
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewPart2()
    }
}
