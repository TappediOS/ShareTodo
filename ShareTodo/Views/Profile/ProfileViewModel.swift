//
//  ProfileViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase
import Purchases

protocol ProfileModelProtocol {
    var presenter: ProfileModelOutput! { get set }
    var isUserSubscribed: Bool { get set }
    
    func fetchUser()
    func checkingIfAUserSubscribed()
}

protocol ProfileModelOutput: class {
    func successFetchUser(user: User)
    
    func userSubscribed()
    func userDontSubscribed()
    
    func userStartSubscribed()
    func userEndSubscribed()
}

final class ProfileModel: ProfileModelProtocol {
    weak var presenter: ProfileModelOutput!
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    var isUserSubscribed = false
    
    init() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchUser() {
        guard let user = Auth.auth().currentUser else { return }
        self.listener = self.firestore.collection("todo/v1/users/").document(user.uid).addSnapshotListener { [weak self] (document, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let document = document else {
                print("The document doesn't exist.")
                return
            }
            
            do {
                let userInfo = try document.data(as: User.self)
                self?.presenter.successFetchUser(user: userInfo!)
            } catch let error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func checkingIfAUserSubscribed() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                return
            }
            
            guard entitlement.isActive == true else {
                self.isUserSubscribed = false
                self.presenter.userDontSubscribed()
                return
            }
            
            self.isUserSubscribed = true
            self.presenter.userSubscribed()
        }
    }
    
    @objc func startSubscribed() {
        self.isUserSubscribed = true
        self.presenter.userStartSubscribed()
    }
    
    @objc func endSubscribed() {
        self.isUserSubscribed = false
        self.presenter.userEndSubscribed()
    }
}
