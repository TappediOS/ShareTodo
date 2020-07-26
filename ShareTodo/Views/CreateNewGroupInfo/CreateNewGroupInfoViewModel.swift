//
//  CreateNewGroupInfoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase

protocol CreateNewGroupInfoModelProtocol {
    var presenter: CreateNewGroupInfoModelOutput! { get set }
    
    func createGroup(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data)
}

protocol CreateNewGroupInfoModelOutput: class {
    func successCreateGroup()
}

final class CreateNewGroupInfoModel: CreateNewGroupInfoModelProtocol {
    weak var presenter: CreateNewGroupInfoModelOutput!
    private var firestore: Firestore!
    
    init() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    func createGroup(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data) {
        let memberIDs = selectedUsers.compactMap { $0.id }
        
        let group = Group(name: groupName, task: groupTask, members: memberIDs, profileImageURL: nil)
        let groupData: [String: Any]
        
        let groupReference = self.firestore.collection("todo").document("v1").collection("groups").document()
        let batch = self.firestore.batch()
        
        do {
            groupData = try Firestore.Encoder().encode(group)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        batch.setData(groupData, forDocument: groupReference)
        
        group.members.forEach { memberID in
            batch.setData([:], forDocument: groupReference.collection("members").document(memberID))
        }
        
        batch.commit { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            self.presenter.successCreateGroup()
        }
    }
}
