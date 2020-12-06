//
//  AccountViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase

protocol AccountModelProtocol {
    var presenter: AccountModelOutput! { get set }
    
    func chekeTheIndexPath(indexPath: IndexPath)
    func fetchUserData()
}

protocol AccountModelOutput: class {
    func successFetchUser(user: User)
    
    func error(error: Error)
}

final class AccountModel: AccountModelProtocol {
    weak var presenter: AccountModelOutput!
    private var firestore: Firestore!
    
    init() {
        self.setupFirestore()
    }
    
    private func setupFirestore() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }
        
        self.firestore.document("todo/v1/users/" + user.uid).getDocument { (document, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            guard let document = document, document.exists else { return }
            guard let user = try? document.data(as: User.self) else { return }
            self.presenter.successFetchUser(user: user)
        }
    }
    
    
    func chekeTheIndexPath(indexPath: IndexPath) {
        guard indexPath.section == 1, indexPath.item == 0 else { return }
        print("dlete")
    }
}
