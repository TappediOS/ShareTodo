//
//  EditGroupModelMock.swift
//  ShareTodoTests
//
//  Created by jun on 2020/10/23.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import ShareTodo

class EditGroupModelMock: EditGroupModelProtocol {
    var presenter: EditGroupModelOutput!
    var group: Group
    var groupUsers: [User]
    var mayRemoveUserUID: String?
    
    var currentUserUID = "id1"
    
    init() {
        let user1 = User(id: "id1", name: "user1", profileImageURL: "u1")
        let user2 = User(id: "id2", name: "user2", profileImageURL: "u2")
        let user3 = User(id: "id3", name: "user3", profileImageURL: "u3")
        let user4 = User(id: "id4", name: "user4", profileImageURL: "u4")
        let user5 = User(id: "id5", name: "user5", profileImageURL: "u5")
        let user6 = User(id: "id6", name: "user6", profileImageURL: "u6")
        var membersID: [String] = [user1.id!, user2.id!, user3.id!, user4.id!, user5.id!, user6.id!]
        membersID.shuffle()
        self.groupUsers = [user1, user2, user3, user4, user5, user6]
        
        self.group = Group(groupID: "group1", name: "Apple", task: "Pie", members: membersID, profileImageURL: nil)
    }
    
    func updateGroup(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data) {
        self.presenter.successSaveGroup()
    }
    
    func inviteUsers(inviteUsers: [User]) {
        var newGroupUsersUID = self.groupUsers.compactMap { $0.id }
        var newGroupUsers = self.groupUsers
        for user in inviteUsers {
            if newGroupUsersUID.contains(user.id ?? "") == true { continue }
            newGroupUsersUID.append(user.id ?? "")
            newGroupUsers.append(user)
        }
        self.groupUsers = newGroupUsers
       
        self.presenter.successInviteUsers()
    }
    
    func selectedUserEqualMe(index: Int) -> Bool {
        guard let selectedUsersUID = self.groupUsers[index].id else { return true }
        
        if self.currentUserUID == selectedUsersUID { return true }
        return false
    }
    
    func getSelectedUser(index: Int) -> User? {
        guard index >= 0 && index < self.groupUsers.count else { return nil }
        return self.groupUsers[index]
    }
    
    func setMayRemoveUserUID(uid: String) {
        self.mayRemoveUserUID = uid
    }
    
    func resetMayRemoveUserUID() {
        self.mayRemoveUserUID = nil
    }
    
    func removeUser() {
        guard let removeUserUID = self.mayRemoveUserUID else { return }
        
        self.groupUsers = self.groupUsers.filter { $0.id != removeUserUID }
        self.presenter.successRemoveUser()
    }
    
    func leaveGroup() {
        guard self.group.groupID != nil else { return }
        let newGroupUsers = self.groupUsers.filter { $0.id != self.currentUserUID }.compactMap { $0.id }
        
        self.presenter.successLeaveGroup()
    }
}
