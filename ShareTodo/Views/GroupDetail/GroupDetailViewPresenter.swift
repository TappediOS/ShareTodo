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
    func didFinishedEditGroup()
    
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
    
    let repository = GroupDetailRepository()

    var group: Group { return self.model.group }
    var groupUsers: [User] { return self.model.groupUsers }
    var isFinishedUsersIDs: [String] { return self.model.isFinishedUsersIDs }
    var numberOfGroupUsers: Int { return self.model.groupUsers.count }
    
    init(model: GroupDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
        self.repository.delegate = self
    }
    
    func didViewDidLoad() {
        self.model.fetchTodayTodo()
    }
    
    func didTapEditGroup() {
        self.view.showEditGroupVC()
    }
    
    func didFinishedEditGroup() {
        guard let groupID = self.model.group.groupID else { return }
        GroupDetailUsecase(repository: repository).fetchGroup(groupID: groupID)
    }
    
    func successFetchTodayTodo() {
        self.view.reloadGroupDetailCollectionView()
    }
}

extension GroupDetailViewPresenter: GroupDetailComplateDelegate {
    func success(group: Group?) {
        guard let group = group else { return }
        self.model.group = group
        //TODO:- navigationTitleも変更すること
        self.view.reloadGroupDetailCollectionView()
    }
    
    func failure(error: Error) {
        print("Error: \(error.localizedDescription)")
        return
    }
}
