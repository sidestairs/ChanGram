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
                //                    .frame(maxWidth: .infinity)
            }
            
            // Sign in with Google
            Button {
                //                showOnboardingPart2.toggle()
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
        .fullScreenCover(isPresented: $showOnboardingPart2) {
            OnboardingViewPart2()
        }
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error signing in"))
        }
    }
    
    // MARK: FUNCTION
    
    func connectToFirebase(name:String, email:String, provider:String, credential:AuthCredential) {
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
