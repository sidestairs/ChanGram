//
//  OnboardingView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    @EnvironmentObject var viewModel: SignInWithGoogle
    
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2:Bool = false
    @State var showError:Bool = false
    
    @State var displayName: String = ""
    @State var email:String = ""
    @State var providerId:String = ""
    @State var provider:String = ""
    
    var body: some View {
        VStack( spacing: 10) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to ChanGrame")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            // Sign in with Apple
            Button {
                //                showOnboardingPart2.toggle()
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
            } label: {
                SigninWithAppleCustom()
                    .frame(height: 60)
                //  .frame(maxWidth: .infinity)
            }
            
            // Sign in with Google
            Button {
                // showOnboardingPart2.toggle()
                viewModel.signIn()
            } label: {
                HStack {
                    Image(systemName: "globe")
                    
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                .cornerRadius(8)
                .font(.system(size: 23, weight: .medium, design: .default))
            }
            .accentColor(.white)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Text("Continue as guest")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .font(.system(size: 23, weight: .medium, design: .default))
            }
            .accentColor(.black)
            
            
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboardingPart2, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            OnboardingViewPart2(displayName: $displayName, email: $email, providerId: $providerId, provider: $provider)
        }
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error signing in"))
        }
    }
    
    // MARK: FUNCTION
    
    func connectToFirebase(name:String, email:String, provider:String, credential:AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { returnedProviderID, isError, isNewUser, returnedUserId in
            
            if let newUser = isNewUser {
                
                if newUser {
                    // new user
                    if let providerID = returnedProviderID, !isError {
                        // SUCCESS
                        
                        // New User
                        self.displayName = name
                        self.email = email
                        self.providerId = providerID
                        self.provider = provider
                        self.showOnboardingPart2.toggle()
                    }
                    else {
                        // ERROR
                        print("Error getting provider ID from log in user to Firebase")
                        self.showError.toggle()
                    }
                    
                } else {
                    // returning user
                    if let userId = returnedUserId {
                        // success
                        AuthService.instance.loginUserToApp(userId: userId) { success in
                            if success {
                                print("successful login existing user")
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                print("unsuccessful login existing user")
                                self.showError.toggle()
                            }
                        }
                    } else {
                        // ERROR
                        print("Error user id from existing user in firebase")
                        self.showError.toggle()
                    }
                }
                
            } else {
                // ERROR
                print("Error getting into from log in user to Firebase")
                self.showError.toggle()
            }
            
            
            
        }
    }
    
    //    func connectToFirebaseApple(credential:AuthCredential) {
    //        Auth.auth().signIn(with: credential) { (authResult, error) in
    //            if (error != nil) {
    //                print("Error getting info from logged in user to firebase")
    //                self.showError.toggle()
    //                return
    //            }
    //            // SUCCESS
    //            self.displayName = Auth.auth().currentUser?.displayName ?? ""
    //            self.email = Auth.auth().currentUser?.email ?? ""
    //            self.showOnboardingPart2.toggle()
    //        }
    //    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
    }
}
