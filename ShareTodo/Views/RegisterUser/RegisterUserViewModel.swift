//
//  RegisterUserViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase

protocol RegisterUserModelProtocol {
    var presenter: RegisterUserModelOutput! { get set }
    
    func registerUser(userName: String, profileImageData: Data)
}

protocol RegisterUserModelOutput: class {
    func successRegisterUser()
    
    func error(error: Error)
}

final class RegisterUserModel: RegisterUserModelProtocol {
    weak var presenter: RegisterUserModelOutput!
    private var firestore: Firestore!
    
    init() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    func registerUser(userName: String, profileImageData: Data) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            guard let user = authResult?.user else { return }
            
            self.registerUserFirebase(uid: user.uid, name: userName)
            self.registerUserImageFireStorage(uid: user.uid, imageData: profileImageData)
        }
    }
    
    func registerUserFirebase(uid: String, name: String) {
        let user = User(id: uid, name: name, profileImageURL: nil, fcmToken: nil, thumbnailImageURL: nil, biography: nil)
        
        do {
            _ = try self.firestore.collection("todo/v1/users").document(uid).setData(from: user) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.presenter.error(error: error)
                    return
                }
            }
            
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
    
    func registerUserImageFireStorage(uid: String, imageData: Data) {
        let storage = Storage.storage()
        let profileImagesRef = storage.reference().child("userProfileImage/" + uid + ".png")
        
        _ = profileImagesRef.putData(imageData as Data, metadata: nil) { (_, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            profileImagesRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                
                guard let downloadURL = url else { return }
                self.registerProfileURLtoFirestore(uid: uid, downloadURL: downloadURL)
            }
        }
    }
    
    func registerProfileURLtoFirestore(uid: String, downloadURL: URL) {
        let downloadURLStr: String = downloadURL.absoluteString
        
        self.firestore.collection("todo/v1/users").document(uid).setData(["profileImageURL": downloadURLStr], merge: true) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            self.presenter.successRegisterUser()
            Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
        }
    }
}
