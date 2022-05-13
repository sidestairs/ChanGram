//
//  SettingsEditTextView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @Binding var profileText: String
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserId: String?
    
    @State var showSuccessAlert: Bool = false
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            
            Button {
                if textIsAppropriate() {
                    saveText()
                }
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

            Spacer()
            
        }
        .padding()
        .frame(maxWidth:.infinity)
        .navigationTitle(title)
    }
    
    // MARK: FUNCTIONS
    
    func dismissView() {
        self.haptics.notificationOccurred(.success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innapropriate things
        
        
        // Checking for bad words
        let badWordArray: [String] = ["shit", "ass"]

        let words = submissionText.components(separatedBy: " ")

        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        // Checking for minimum character count
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func saveText() {
        
        guard let userId = currentUserId else { return }
        
        switch settingsEditTextOption {
        case .displayName:
            
            // Update the UI on the Profile
            self.profileText = submissionText
        
            // Update the UserDefault
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)
        
            // Update on all of the user's posts
            DataService.instance.updateDisplayNameOnPosts(userId: userId, displayName: submissionText)
        
            // Update on the user's profile in DB
            AuthService.instance.updateUserDisplayName(userId: userId, displayName: submissionText) { (success) in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
            
        case .bio:
            
            // Update the UI on the Profile
            self.profileText = submissionText

            // Update the UserDefault
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            
            // Update on the user's profile in DB
            AuthService.instance.updateUserBio(userId: userId, bio: submissionText) { (success) in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
            
            
        }
        
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Test Title", description: "This is a description", placeholder: "Test Placeholder", settingsEditTextOption: .displayName, profileText: $text)
                .preferredColorScheme(.light)
        }
    }
}
