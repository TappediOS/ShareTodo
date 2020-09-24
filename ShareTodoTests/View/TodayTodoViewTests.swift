//
//  TodayTodoViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/08.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo
import Firebase

class TodayTodoModelMock: TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput!
    var groups: [Group] = Array()
    var todos: [Todo] = Array()
    
    func fetchGroups() {
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: "https")
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user4"], profileImageURL: nil)
        
        self.groups = [group1, group2, group3]
    }
    
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String) {
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        
        self.todos = [todo1, todo2]
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
        self.presenter.successUnfinishedTodo()
    }
    
    func finishedTodo(index: Int) {
        if index == 2 {
            self.todos.append(Todo(isFinished: true, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date())))
            return
        }
        self.todos[index].isFinished = true
    }
}

class TodayTodoViewTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testGetTodayFormat() throws {
        let todayTodoModel = TodayTodoModel()
        let exp = todayTodoModel.getTodayFormat()
        let expArray = exp.components(separatedBy: "_")
                
        XCTAssertEqual(expArray.count, 3)
        XCTAssertEqual(expArray[0].map { String($0) }.count, 4)
        XCTAssertEqual(expArray[1].map { String($0) }.count, 2)
        XCTAssertEqual(expArray[2].map { String($0) }.count, 2)
        
        let year = Int(expArray[0])!
        let month = Int(expArray[1])!
        let day = Int(expArray[2])!
        
        XCTAssertGreaterThanOrEqual(year, 2020)
        
        XCTAssertGreaterThanOrEqual(month, 1)
        XCTAssertLessThanOrEqual(month, 12)
        
        XCTAssertGreaterThanOrEqual(day, 1)
        XCTAssertLessThanOrEqual(day, 31)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
