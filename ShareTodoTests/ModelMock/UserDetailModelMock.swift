//
//  UserDetailModelMock.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import ShareTodo

class UserDetailModelMock: UserDetailModelProtocol {
    var presenter: UserDetailModelOutput!
    var group: Group = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
    var user: User = User(id: "user1", name: "Joe", profileImageURL: nil)
    var todos: [Todo] = Array()
    let dateFormatter = DateFormatter()
    
    init() {
        self.setupDataFormatter()
    }
    
    func setupDataFormatter() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    func fetchTodoList() {
        // swiftlint:disable comma
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*1)))
        let todo3 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*2)))
        let todo4 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*3)))
        let todo5 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*4)))
        let todo6 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*5)))
        let todo7 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*6)))
        let todo8 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*7)))
        let todo9 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*8)))
        // swiftlint:enable comma
        
        self.todos = [todo1, todo2, todo3, todo4, todo5, todo6, todo7, todo8, todo9]
        self.todos.shuffle()
        self.presenter.successFetchTodoList()
    }
    
    func isTheDayAWeekAgo(date: Date) -> Bool {
        let aWeekAgo = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
        let tomorrow = Date(timeIntervalSinceNow: 60 * 60 * 24)
        return aWeekAgo < date && date < tomorrow
    }
    
    func getTodoListAsFinishedDate() -> [String] {
        return self.todos.filter { $0.isFinished }.reduce([String]()) { list, todo in
            var list = list
            guard todo.isFinished else { return list }
            guard let createdAt = todo.createdAt?.dateValue() else { return list }
            list.append(dateFormatter.string(from: createdAt))
            return list
        }
    }
    
    func getContaintFinishedDate(date: Date) -> Bool {
        let list = getTodoListAsFinishedDate()
        return list.contains(self.dateFormatter.string(from: date))
    }
    
    func calculateForNavigationImage(height: Double) -> (scale: Double, xTranslation: Double, yTranslation: Double) {
        return (0.0, 0.0, 0.0)
    }
    
    
}
