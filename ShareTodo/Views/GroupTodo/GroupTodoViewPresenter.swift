//
//  GroupTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupTodoViewPresenterProtocol {
    var view: GroupTodoViewPresenterOutput! { get set }
    var numberOfGroup: Int { get }
    var group: [Group] { get }
    var groupUsers: [[User]] { get }
    
    func didViewDidLoad()
    func didTapMakeGroupButton()
}

protocol GroupTodoViewPresenterOutput: class {
    func reloadGroupTableView()
    func showCreateNewGroupVC()
}

final class GroupTodoViewPresenter: GroupTodoViewPresenterProtocol, GroupTodoModelOutput {
    weak var view: GroupTodoViewPresenterOutput!
    private var model: GroupTodoModelProtocol
    
    var group: [Group] { return self.model.group }
    var numberOfGroup: Int { return self.model.group.count }
    var groupUsers: [[User]] { return self.model.groupUsers }
    
    init(model: GroupTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchGroup()
    }
    
    func didTapMakeGroupButton() {
        self.view.showCreateNewGroupVC()
    }
    
    func successFetchGroup() {
        self.model.fetchGroupsUsersNames()
    }
}
