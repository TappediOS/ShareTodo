//
//  GroupDetailViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupDetailModelProtocol {
    var presenter: GroupDetailModelOutput! { get set }
    var group: Group { get set }
    var groupUsers: [User] { get set }
}

protocol GroupDetailModelOutput: class {
    
}

final class GroupDetailModel: GroupDetailModelProtocol {
    weak var presenter: GroupDetailModelOutput!
    var group: Group
    var groupUsers: [User]
    
    init(group: Group, groupUsers: [User]) {
        self.group = group
        self.groupUsers = groupUsers
    }
    
}
