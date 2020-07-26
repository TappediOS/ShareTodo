//
//  GroupTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupTodoModelProtocol {
    var presenter: GroupTodoModelOutput! { get set }
    var group: [String] { get set }
    
    func fetchGroup()
}

protocol GroupTodoModelOutput: class {
    func successFetchGroup()
}

final class GroupTodoModel: GroupTodoModelProtocol {
    weak var presenter: GroupTodoModelOutput!
    var group = ["test", "test2", "Picker", "Roker"]
    
    func fetchGroup() {
        self.presenter.successFetchGroup()
    }
}
