//
//  AuthService.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 10/5/22.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore

let DB_BASE = Firestore.firestore()

class AuthService {
    // MARK: Properties
    
    static let instance = AuthService()
    
    private var REF_USERS = DB_BASE.collection("users")
    
    // MARK: AUTH USER FUNCTIONS
    
    func logInUserToFirebase(credential:AuthCredential, handler: @escaping(_ providerID:String?, _ isError:Bool, _ isNewUser:Bool?, _ userId:String?)->()) {
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print("Error logging in to Firebase")
                handler(nil, true, nil, nil)
                return
            }
            
            guard let providerId = authResult?.user.uid else {
                print("Error getting provider id")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerId: providerId) { existingUserId in
                if let userId = existingUserId {
                    // user exists, log in immediately
                    handler(providerId, false, false, userId)
                } else {
                    // user does not exists
                    handler(providerId, false, true, nil)
                }
            }
        }
    }
    
    func loginUserToApp(userId: String, handler: @escaping(_ success:Bool)->()) {
        // Get the user info
        getUserInfo(forUserId: userId) { returnedName, returnedBio in
            if let name = returnedName, let bio = returnedBio {
                // success
                print("success getting user info")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    // set users into our app
                    UserDefaults.standard.set(userId, forKey: CurrentUserDefaults.userId)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                }
                
                
            } else {
                // error
                print("Error logging in")
                handler(false)
            }
        }
    }
    
    func logoutUser(handler:@escaping(_ success:Bool)->()) {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
//                    UserDefaults.standard.removeObject(forKey: CurrentUserDefaults.userId)
                defaultsDictionary.keys.forEach { key in
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
        } catch {
            print("Error \(error)")
            handler(false)
            return
        }
        
        handler(true)
    }
    
    func createNewUserInDatabase(name:String, email:String, providerId: String, provider:String, profileImage:UIImage, handler: @escaping(_ userId:String?)->()) {
        // setup a user document
        let document = REF_USERS.document()
        let userId = document.documentID
        
        // upload profile image
        ImageManager.instance.uploadProfileImage(userId: userId, image: profileImage)
        
        let userData: [String:Any] = [
            DatabaseUserField.displayName: name,
            DatabaseUserField.email : email,
            DatabaseUserField.providerId: providerId,
            DatabaseUserField.userId : userId,
            DatabaseUserField.bio :"",
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        document.setData(userData) { (error) in
            
            if let error = error {
                // error
                print("Error uploading data \(error)")
                handler(nil)
            } else {
                // success
                handler(userId)
            }
        }
    }
    
    private func checkIfUserExistsInDatabase(providerId:String, handler:@escaping(_ existingUserId:String?)->()) {
        REF_USERS.whereField(DatabaseUserField.providerId, isEqualTo: providerId).getDocuments { querySnapshot, error in
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                // SUCCESS
                let existingUserId = document.documentID
                handler(existingUserId)
                return
            } else {
                // ERROR NEW USER
                handler(nil)
                return
            }
        }
    }
    
    // MARK: Get user function
    
    func getUserInfo(forUserId userId: String, handler: @escaping(_ name: String?, _ bio:String?)->()) {
        REF_USERS.document(userId).getDocument { documentSnapshot, error in
            if let document = documentSnapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                print("Success getting user info")
                handler(name, bio)
                return
            } else {
                print("Error getting user info")
                handler(nil, nil)
                return
            }
        }
    }
}
