//
//  AuthService.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 10/5/22.
//

import Foundation
import FirebaseAuth


class AuthService {
    // MARK: Properties
    
    static let instance = AuthService()
    
    // MARK: AUTH USER FUNCTIONS
    
    func logInUserToFirebase(credential:AuthCredential, handler: @escaping(_ providerID:String?, _ isError:Bool)->()) {
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print("Error logging in to Firebase")
                handler(nil, true)
                return
            }
            
            guard let providerId = authResult?.user.uid else {
                print("Error getting provider id")
                handler(nil, true)
                return
            }
            
            // Successfully connect to firebase
            handler(providerId, false)
            
        }
    }
}
