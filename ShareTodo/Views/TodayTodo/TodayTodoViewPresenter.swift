//
//  TodayTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoViewPresenterProtocol {
    var view: TodayTodoViewPresenterOutput! { get set }
    var numberOfGroups: Int { get }
    var groups: [Group] { get }
    var todos: [Todo] { get }
    
    func didViewDidLoad()
    func didTapRadioButton(index: Int)
}

protocol TodayTodoViewPresenterOutput: class {
    func reloadTodayTodoCollectionView()
    func showRequestAllowNotificationView()
}

final class TodayTodoViewPresenter: TodayTodoViewPresenterProtocol, TodayTodoModelOutput {
    weak var view: TodayTodoViewPresenterOutput!
    private var model: TodayTodoModelProtocol
    
    var numberOfGroups: Int {
        return self.model.groups.count
    }
    
    var groups: [Group] {
        return self.model.groups
    }
    
    var todos: [Todo] {
        return self.model.todos
    }
    
    init(model: TodayTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        if self.model.isFirstOpen() { self.view.showRequestAllowNotificationView() }
        self.model.fetchGroups()
    }
    
    func successFetchTodayTodo() {
        self.view.reloadTodayTodoCollectionView()
    }
    
    func didTapRadioButton(index: Int) {
        //self.model.
    }
}
