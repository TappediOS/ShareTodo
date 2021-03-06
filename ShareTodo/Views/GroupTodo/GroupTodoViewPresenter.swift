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
    func didTapGroupTableViewCell(index: Int)
}

protocol GroupTodoViewPresenterOutput: class {
    func reloadGroupTableView()
    func showCreateNewGroupVC()
    
    func startActivityIndicator()
    func stopActivityIndicator()
    
    func setTableViewInsetBottoms(isSubscribed: Bool)
    
    func segueGroupDetailViewController(index: Int)
    
    func showErrorAleartView(error: Error)
    
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
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
        self.view.startActivityIndicator()
        self.model.fetchGroup()
        self.model.checkingIfAUserSubscribed()
    }
    
    func didTapMakeGroupButton() {
        self.view.showCreateNewGroupVC()
        self.view.impactFeedbackOccurred()
    }
    
    func successFetchGroup() {
        self.view.stopActivityIndicator()
        self.model.fetchGroupsUsersNames()
    }
    
    func successFetchUsersName() {
        self.view.reloadGroupTableView()
    }
    
    func didTapGroupTableViewCell(index: Int) {
        self.view.segueGroupDetailViewController(index: index)
        self.view.impactFeedbackOccurred()
    }
    
    func userSubscribed(isSubscribed: Bool) {
        self.view.setTableViewInsetBottoms(isSubscribed: isSubscribed)
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
        self.view.noticeFeedbackOccurredError()
    }
}
