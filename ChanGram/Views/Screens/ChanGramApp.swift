//
//  ChanGramApp.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct ChanGramApp: App {
    
    @StateObject var viewModel = SignInWithGoogle()
    
    init() {
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
            //                .onOpenURL { URL in
            //                    GIDSignIn.sharedInstance.handle(URL)
            //                }
        }
    }
}


extension ChanGramApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
