//
//  TodayTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput! { get set }
    var todayTodo: [String] { get set }
    
    func fetchTodayTodo()
}

protocol TodayTodoModelOutput: class {
    func successFetchTodayTodo()
}

final class TodayTodoModel: TodayTodoModelProtocol {
    weak var presenter: TodayTodoModelOutput!
    var todayTodo = ["test", "lost", "cooked", "lost", "cat", "lock", "la", "ja", "en", "ko", "fr"]
    
    func fetchTodayTodo() {
        self.presenter.successFetchTodayTodo()
    }
}
