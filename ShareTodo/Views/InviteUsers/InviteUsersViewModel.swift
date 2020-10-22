//
//  InviteUsersViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/10/22.
//  Copyright © 2020 jun. All rights reserved.
//

protocol InviteUsersModelProtocol {
    var presenter: InviteUsersModelOutput! { get set }
}

protocol InviteUsersModelOutput: class {
    
}

final class InviteUsersModel: InviteUsersModelProtocol {
    weak var presenter: InviteUsersModelOutput!
}

