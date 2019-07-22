//
//  ProfileViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 09/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewModel {
    var authListener: AuthStateDidChangeListenerHandle!
    
    var onGotStatus: ((User) -> ())?
    var onNoChanges: (() -> ())?
    var onSignedOut: (() -> ())?
    var onErrorSignOut: ((Error) -> ())?
    var onGotPicture: ((UIImage)->())?
    
    func trackUserStatus() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.onGotStatus?(user)
            } else {
                self?.onNoChanges?()
            }
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            onSignedOut?()
        } catch {
            onErrorSignOut?(error)
        }
    }
    func saveProfilePicture(_ picture: UIImage) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { print("Can't save profile, you must log in!"); return }
        guard let data = picture.jpegData(compressionQuality: 0.75) else { return }
        
        db.collection(user.uid).document("UserInfo").setData([
            "profilePicture": data
        ]) { err in
            if let err = err {
                print("Error while writing to collection \(err)")
            } else {
                print("Profile picture saved!")
            }
        }
    }
    func loadProfilePicture() {
        let db = Firestore.firestore()
        var picture: UIImage!
        guard let user = Auth.auth().currentUser else { print("Can't load profile, you must log in!"); return }
        
        db.collection(user.uid).document("UserInfo").getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()!["profilePicture"] as! Data
                picture = UIImage(data: data)
                self?.onGotPicture?(picture)
            }
        }
    }
    
}
