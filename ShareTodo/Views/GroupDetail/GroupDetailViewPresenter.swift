//
//  GroupDetailViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupDetailViewPresenterProtocol {
    var view: GroupDetailViewPresenterOutput! { get set }
    var group: Group { get }
    var groupUsers: [User] { get }
    var isFinishedUsersIDs: [String] { get }
    
    func didViewDidLoad()
    func didTapEditGroup()
}

protocol GroupDetailViewPresenterOutput: class {
    func reloadGroupDetailCollectionView()
    func showEditGroupVC()
}

final class GroupDetailViewPresenter: GroupDetailViewPresenterProtocol, GroupDetailModelOutput {
    weak var view: GroupDetailViewPresenterOutput!
    private var model: GroupDetailModelProtocol

    var group: Group { return self.model.group }
    var groupUsers: [User] { return self.model.groupUsers }
    var isFinishedUsersIDs: [String] { return self.model.isFinishedUsersIDs }
    var numberOfGroupUsers: Int { return self.model.groupUsers.count }
    
    init(model: GroupDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchTodayTodo()
    }
    
    func didTapEditGroup() {
        self.view.showEditGroupVC()
    }
    
    func successFetchTodayTodo() {
        self.view.reloadGroupDetailCollectionView()
    }
}
