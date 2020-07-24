//
//  TodayTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput! { get set }
}

protocol TodayTodoModelOutput: class {
    
}

final class TodayTodoModel: TodayTodoModelProtocol {
    weak var presenter: TodayTodoModelOutput!
}
