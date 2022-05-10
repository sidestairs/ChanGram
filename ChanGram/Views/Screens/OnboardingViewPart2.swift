//
//  OnboardingViewPart2.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import GoogleSignIn

struct OnboardingViewPart2: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email:String
    @Binding var providerId:String
    @Binding var provider:String
    
    @State var showImagePicker: Bool = false
    @State var showError:Bool = false
    
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
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error creating profile"))
        }
    }
    
    // MARK: FUNCTION
    
    func createProfile() {
        print("Create Profile")
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerId: providerId, provider: provider, profileImage: imageSelected) { returnedUserId in
            if let userId = returnedUserId {
                // success
                print("Successfully create new users")
                
                AuthService.instance.loginUserToApp(userId: userId) { success in
                    if (success) {
                        print("user logged in")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    } else {
                        print("error logging in")
                    }
                }
                
            } else {
                // error
                print("Error creating user in database")
                self.showError.toggle()
            }
        }
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    @State static var testString: String = "Test"
    
    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, email: $testString, providerId: $testString, provider: $testString)
    }
}
