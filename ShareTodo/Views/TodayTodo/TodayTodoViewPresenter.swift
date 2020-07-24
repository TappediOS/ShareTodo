//
//  TodayTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoViewPresenterProtocol {
    var view: TodayTodoViewPresenterOutput! { get set }
}

protocol TodayTodoViewPresenterOutput: class {
    
}

final class TodayTodoViewPresenter: TodayTodoViewPresenterProtocol, TodayTodoModelOutput {
    weak var view: TodayTodoViewPresenterOutput!
    private var model: TodayTodoModelProtocol
    
    init(model: TodayTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
