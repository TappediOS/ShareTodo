//
//  EditGroupViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

protocol EditGroupModelProtocol {
    var presenter: EditGroupModelOutput! { get set }
    var group: Group { get set }
    var groupUsers: [User] { get set }
}

protocol EditGroupModelOutput: class {
    
}

final class EditGroupModel: EditGroupModelProtocol {
    weak var presenter: EditGroupModelOutput!
    var group: Group
    var groupUsers: [User]
    
    init(group: Group, groupUsers: [User]) {
        self.group = group
        self.groupUsers = groupUsers
    }
}
