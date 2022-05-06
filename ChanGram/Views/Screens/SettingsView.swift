//
//  SettingsView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.purpleColor)
                }
                .padding()
                
                // MARK: SECTION 3: Application
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")) {
                    
                    SettingsRowView(leftIcon: "folder.fill", text: "Privacy policy", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "globe", text: "Website", color: Color.MyTheme.yellowColor)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
