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
    var group: Group = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil, createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*15)))
    var user: User = User(id: "user1", name: "Joe", profileImageURL: nil, fcmToken: nil, thumbnailImageURL: nil, biography: nil)
    var todos: [Todo] = Array()
    var isUserSubscribed: Bool = false
    let dateFormatter = DateFormatter()
    
    init() {
        self.setupDataFormatter()
        self.setupNotificationCenter()
    }
    
    func setupDataFormatter() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startSubscribed), name: .startSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endSubscribed), name: .endSubscribedNotification, object: nil)
    }
    
    func fetchTodoList() {
        // swiftlint:disable comma
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*0)))
        let todo2 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*1)))
        let todo3 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*2)))
        let todo4 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*3)))
        let todo5 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*4)))
        let todo6 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*5)))
        let todo7 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*6)))
        let todo8 = Todo(isFinished: true,  userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*7)))
        let todo9 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*8)))
        let todo10 = Todo(isFinished: true, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*9)))
        let todo11 = Todo(isFinished: true, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*10)))
        let todo12 = Todo(isFinished: true, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date(timeIntervalSinceNow: -60*60*24*11)))
        // swiftlint:enable comma
        
        self.todos = [todo1, todo2, todo3, todo4, todo5, todo6, todo7, todo8, todo9, todo10, todo11, todo12]
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
    
    func getMinimumDate() -> Date {
        guard let groupCreatedDate = self.group.createdAt?.dateValue() else {
            // `groupCreatedDate`が`nil`ならば，Todosの中から一番古い日を取得する
            let list: [Date] = self.todos.filter { $0.isFinished }.reduce([Date]()) { list, todo in
                var list = list
                guard todo.isFinished else { return list }
                guard let createdAt = todo.createdAt?.dateValue() else { return list }
                list.append(createdAt)
                return list
            }.sorted()
            
            guard let first = list.first else { return Date(timeIntervalSinceNow: -60 * 60 * 24 * 30) }
            return first
        }
        
        return groupCreatedDate
    }
    
    // サブスクはtrueに設定する。もしfalseにしたければ関数`changeUserSubscribedIsFalse()`を呼ぶ
    func checkingIfAUserSubscribed() {
        self.isUserSubscribed = true
        self.presenter.userSubscribed()
    }
    
    public func changeUserSubscribedIsFalse() {
        self.isUserSubscribed = false
    }
    
    @objc func startSubscribed() {
        self.presenter.userStartSubscribed()
    }
    
    @objc func endSubscribed() {
        self.presenter.userEndSubscribed()
    }
    
}
