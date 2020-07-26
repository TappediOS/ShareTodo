//
//  TodayTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoViewPresenterProtocol {
    var view: TodayTodoViewPresenterOutput! { get set }
    var numberOfTodayTodo: Int { get }
    var todayTodos: [String] { get }
    
    func didViewDidLoad()
    func didTapRadioButton(index: Int)
}

protocol TodayTodoViewPresenterOutput: class {
    func reloadTodayTodoCollectionView()
}

final class TodayTodoViewPresenter: TodayTodoViewPresenterProtocol, TodayTodoModelOutput {
    weak var view: TodayTodoViewPresenterOutput!
    private var model: TodayTodoModelProtocol
    
    var numberOfTodayTodo: Int {
        return self.model.todayTodo.count
    }
    
    var todayTodos: [String] {
        return self.model.todayTodo
    }
    
    init(model: TodayTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchTodayTodo()
    }
    
    func successFetchTodayTodo() {
        self.view.reloadTodayTodoCollectionView()
    }
    
    func didTapRadioButton(index: Int) {
        
    }
}
