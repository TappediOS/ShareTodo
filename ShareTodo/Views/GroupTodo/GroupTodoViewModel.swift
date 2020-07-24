//
//  GroupTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupTodoModelProtocol {
    var presenter: GroupTodoModelOutput! { get set }
}

protocol GroupTodoModelOutput: class {
    
}

final class GroupTodoModel: GroupTodoModelProtocol {
    weak var presenter: GroupTodoModelOutput!
}

