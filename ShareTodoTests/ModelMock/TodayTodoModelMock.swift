//
//  TodayTodoModelMock.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

@testable import ShareTodo
import Firebase

class TodayTodoModelMock: TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput!
    var groups: [Group] = Array()
    var todos: [Todo] = Array()
    var isUserSubscribed: Bool = false
    
    init() {
        self.setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startSubscribed), name: .startSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endSubscribed), name: .endSubscribedNotification, object: nil)
    }
    
    func fetchGroups() {
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil, createdAt: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: nil, createdAt: nil)
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user3", "user4"], profileImageURL: nil, createdAt: nil)
        
        self.groups = [group1, group2, group3]
        self.fetchTodayTodo(groupDocuments: [], userID: "user1")
    }
    
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String) {
        let todo1 = Todo(isFinished: false, message: nil, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, message: "Hello World", userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        
        self.todos = [todo1, todo2]
        self.presenter.successFetchTodayTodo()
    }
    
    func setFcmToken() {
        return
    }
    
    func isFirstOpen() -> Bool {
        return false
    }
    
    func isContainsTodoInGroups(index: Int) -> Bool {
        let group = groups[index]
        return !self.todos.filter({ $0.groupID == group.groupID ?? ""}).isEmpty
    }
    
    func isFinishedTodo(index: Int) -> Bool {
        guard isContainsTodoInGroups(index: index) else { return false }
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        
        if let todo = todo { return todo.isFinished }
        return false
        
    }
    
    func getFinishedTodoIndex(groupIndex: Int) -> Int? {
        for tmp in 0 ..< todos.count {
            if self.todos[tmp].groupID == self.groups[groupIndex].groupID ?? "" { return tmp }
        }
        return nil
    }
    
    func unfinishedTodo(index: Int) {
        guard let finishedTodoIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        self.todos[finishedTodoIndex].isFinished = false
        self.todos[finishedTodoIndex].message = nil
        self.presenter.successUnfinishedTodo()
    }
    
    func finishedTodo(index: Int) {
        if index == 2 {
            self.todos.append(Todo(isFinished: true, message: nil, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date())))
            return
        }
        self.todos[index].isFinished = true
    }
    
    func isWrittenMessage(index: Int) -> Bool {
        guard isContainsTodoInGroups(index: index) else { return false }
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        
        if let todo = todo, let message = todo.message, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        return false
    }
    
    func writeMessage(message: String, index: Int) {
        self.todos[index].message = message
        self.presenter.successWriteMessage()
    }
    
    func cancelMessage(index: Int) {
        guard let cancelMessageIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        self.todos[cancelMessageIndex].message = nil
        self.presenter.successCancelMessage()
    }
    
    // サブスクはtrueに設定する。もしfalseにしたければ関数`changeUserSubscribedIsFalse()`を呼ぶ
    func checkingIfAUserSubscribed() {
        self.isUserSubscribed = true
        self.presenter.userSubscribed()
    }
    
    public func changeUserSubscribedIsFalse() {
        self.isUserSubscribed = false
    }
    
    func countUpOpenApp() {
        return
    }
    
    func shouldRequestStoreReviewOpenAppCount() -> Bool {
        return false
    }
    
    func countUpRequestFinishTodo() {
        return
    }
    
    func shouldRequestStoreReviewFinishTodoCount() -> Bool {
        return false
    }
    
    @objc func startSubscribed() {
        self.presenter.userStartSubscribed()
    }
    
    @objc func endSubscribed() {
        self.presenter.userEndSubscribed()
    }

    func requestAdsTrackingIfNeeded() {
        return
    }
}
