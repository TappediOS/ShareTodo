//
//  GroupUsecase.swift
//  ShareTodo
//
//  Created by jun on 2020/09/14.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase

final class GroupDetailUsecase {
    var group: Group
    var groupUsers: [User]
    var isFinishedUsersIDs: [String] = Array()
    
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    init(group: Group, groupUsers: [User]) {
        self.group = group
        self.groupUsers = groupUsers
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

    func getGroup() -> Group {
        return self.group
    }
    
    func getGroupUsers() -> [User] {
        return self.groupUsers
    }
    
    func fetchGroup(completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let groupID = self.group.groupID else { return }
        let documentRef = "todo/v1/groups/" + groupID
        
        self.listener = self.firestore.document(documentRef).addSnapshotListener { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                print("The document doesn't exist.")
                completion(.success(()))
                return
            }
            
            do {
                let groupData = try document.data(as: Group.self)
                guard let group = groupData else { return }
                self.group = group
                completion(.success(()))
            } catch let error {
                print("Error happen.")
                completion(.failure(error))
            }
        }
    }
    
    func fetchTodayTodo(completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let groupID = self.group.groupID else { return }
        let collectionRef = "todo/v1/groups/" + groupID + "/todo"
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        
        let startDate: String = formatter.string(from: Date())
        let startTime: Date = formatter.date(from: startDate) ?? Date(timeIntervalSince1970: 0)
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        self.listener = self.firestore.collection(collectionRef).whereField("createdAt", isGreaterThanOrEqualTo: startTimestamp).whereField("isFinished", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let documents = documentSnapshot?.documents else {
                print("The document dosent exist.")
                completion(.success(()))
                return
            }
            
            let result = documents.compactMap { queryDocumentSnapshot -> Todo? in
                return try? queryDocumentSnapshot.data(as: Todo.self)
            }
                        
            self.isFinishedUsersIDs = result.map { $0.userID }
            
            completion(.success(()))
        }
    }
}
