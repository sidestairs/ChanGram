//
//  SettingsView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showSignOutError:Bool = false
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                // MARK: SECTION 1: CHANGRAM
                GroupBox(label: SettingsLabelView(labelText: "ChanGram", labelImage: "dot.radiowaves.left.and.right")) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(40)
                        
                        Text("This is the number 1 app in the world")
                            .font(.footnote)
                    }
                }
                .padding()
                
                // MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill")) {
                    
                    NavigationLink(destination: SettingsEditTextView(submissionText: "Current Display Name", title: "Display Name", description: "You can edit your display name here, this will be seen by other users on your profile and your post.", placeholder: "Your display name here")) {
                        
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    }
                    
                    NavigationLink(destination: SettingsEditTextView(submissionText: "Current Bio Here", title: "Profile Bio", description: "Your bio is a great place to let other users know about you.", placeholder: "Your bio here")) {
                        
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    }
                    
                    
                    NavigationLink(destination: SettingEditImageView(title: "Profile Image", description: "Your profile image will be showed to everybody.", selectedImage: UIImage(named:"dog1")!)) {
                        
                        SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    }
                    
                    
                    Button {
                        signOut()
                    } label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.purpleColor)
                    }
                    .alert(isPresented: $showSignOutError) {
                        return Alert(title: Text("Error signing out"))
                    }
                }
                .padding()
                
                // MARK: SECTION 3: Application
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")) {
                    
                    Button {
                        openCustomURL(urlString: "https://google.com")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy policy", color: Color.MyTheme.yellowColor)
                    }
                    
                    Button {
                        openCustomURL(urlString: "https://google.com")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yellowColor)
                    }
                    
                    Button {
                        openCustomURL(urlString: "https://google.com")
                    } label: {
                        SettingsRowView(leftIcon: "globe", text: "Website", color: Color.MyTheme.yellowColor)
                    }

                }
                .padding()
                
                // MARK: SECTION 4: Sign off
                
                GroupBox{
                    Text("This app is made with love. \n All Right Reserved. \n Copyright 2022")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth:.infinity)
                }
                .padding()
                .padding(.bottom, 80)

            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .accentColor(.primary)
                }))
        }
        
        
    }
    
    // MARK: FUNCTION
    
    func openCustomURL(urlString:String) {
        guard let url = URL(string: urlString) else {return}
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        AuthService.instance.logoutUser { success in
            if success {
                print("Successfully logout")
                
                // dismiss setting values
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                print("error logging out")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
