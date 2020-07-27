//
//  GroupTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase

protocol GroupTodoModelProtocol {
    var presenter: GroupTodoModelOutput! { get set }
    var group: [Group] { get set }
    
    func fetchGroup()
}

protocol GroupTodoModelOutput: class {
    func successFetchGroup()
}

final class GroupTodoModel: GroupTodoModelProtocol {
    weak var presenter: GroupTodoModelOutput!
    var group: [Group] = Array()
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    init() {
        self.setUpFirestore()
    }
    
    deinit {
        listener?.remove()
    }
    
    func setUpFirestore() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    
    func fetchGroup() {
        guard let user = Auth.auth().currentUser else { return }
        
        self.listener = self.firestore.collection("todo/v1/groups/").whereField("members", arrayContains: user.uid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = documentSnapshot?.documents else {
                print("The document doesn't exist.")
                return
            }
            
            self?.group = documents.compactMap { queryDocumentSnapshot -> Group? in
                return try? queryDocumentSnapshot.data(as: Group.self)
            }
            
            self?.presenter.successFetchGroup()
        }
    }
}
