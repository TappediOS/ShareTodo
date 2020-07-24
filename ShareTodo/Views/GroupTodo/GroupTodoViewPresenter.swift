//
//  GroupTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupTodoViewPresenterProtocol {
    var view: GroupTodoViewPresenterOutput! { get set }
}

protocol GroupTodoViewPresenterOutput: class {
    
}

final class GroupTodoViewPresenter: GroupTodoViewPresenterProtocol, GroupTodoModelOutput {
    weak var view: GroupTodoViewPresenterOutput!
    private var model: GroupTodoModelProtocol
    
    init(model: GroupTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
