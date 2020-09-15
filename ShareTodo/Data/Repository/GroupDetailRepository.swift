//
//  GroupDetailRepository.swift
//  ShareTodo
//
//  Created by jun on 2020/09/15.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase

protocol GroupDetailComplateDelegate {
    func success(group: Group?)
    func failure(error: Error)
}

class GroupDetailRepository: GroupDetailRepositoryProtocol {
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    var delegate: GroupDetailComplateDelegate?
    
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
    
    func fetchGroup(groupID: String) {
        let documentRef = "todo/v1/groups/" + groupID
        
        self.listener = self.firestore.document(documentRef).addSnapshotListener { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                self.delegate?.failure(error: error)
                return
            }
            
            guard let document = document, document.exists else {
                print("The document doesn't exist.")
                self.delegate?.success(group: nil)
                return
            }
            
            do {
                let groupData = try document.data(as: Group.self)
                guard let group = groupData else { return }
                
                self.delegate?.success(group: group)
            } catch let error {
                print("Error happen.")
                self.delegate?.failure(error: error)
            }
        }
    }
}
