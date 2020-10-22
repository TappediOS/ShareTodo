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
    
    func didFinishedEditGroup(group: Group, groupUsers: [User])
    
    func didViewDidLoad()
    func didTapEditGroup()
    func didTapGroupDetailCollectionViewuserCell(index: Int)
}

protocol GroupDetailViewPresenterOutput: class {
    func reloadGroupDetailCollectionView()
    func setNavigationBarTitle(title: String)
    func showEditGroupVC()
    func segueUserDetailViewController(index: Int)
}

final class GroupDetailViewPresenter: GroupDetailViewPresenterProtocol, GroupDetailModelOutput {
    weak var view: GroupDetailViewPresenterOutput!
    private var model: GroupDetailModelProtocol
    
    let repository = GroupRepository()

    var group: Group { return self.model.group }
    var groupUsers: [User] { return self.model.groupUsers }
    var isFinishedUsersIDs: [String] { return self.model.isFinishedUsersIDs }
    var numberOfGroupUsers: Int { return self.model.groupUsers.count }
    
    init(model: GroupDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
        GroupDataStore.groupDataStore.delegate = self
    }
    
    func didViewDidLoad() {
        self.model.fetchTodayTodo()
    }
    
    func didTapEditGroup() {
        self.view.showEditGroupVC()
    }
    
    func didFinishedEditGroup(group: Group, groupUsers: [User]) {
        self.model.groupUsers = groupUsers
        self.view.setNavigationBarTitle(title: group.name)
        self.view.reloadGroupDetailCollectionView()
    }
    
    func didTapGroupDetailCollectionViewuserCell(index: Int) {
        self.view.segueUserDetailViewController(index: index)
    }
    
    func successFetchTodayTodo() {
        self.view.reloadGroupDetailCollectionView()
    }
}

extension GroupDetailViewPresenter: GroupCompleteDelegate {
    func success(dataStore: GroupDataStore) {
        print(dataStore.groups)
    }
    
    func failure(error: Error) {
        print("Error: \(error.localizedDescription)")
        return
    }
}
