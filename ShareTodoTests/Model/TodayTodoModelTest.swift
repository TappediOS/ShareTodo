//
//  TodayTodoModelTest.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/24.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
import Firebase
@testable import ShareTodo

class TodayTodoModelTests: XCTestCase {
    
    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {

    }

    func testGetTodayFormat() throws {
        let model = TodayTodoModel()
        let exp = model.getTodayFormat()
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
    
    func test_isContainsTodoInGroups() {
        let model = TodayTodoModelMock()
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: nil)
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user3", "user4"], profileImageURL: nil)
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        let todo3 = Todo(isFinished: true, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date()))
        model.groups = [group1, group2, group3]
        
        model.todos = [todo1, todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertTrue(model.isContainsTodoInGroups(index: 0))
            XCTAssertTrue(model.isContainsTodoInGroups(index: 1))
            XCTAssertFalse(model.isContainsTodoInGroups(index: 2))
        }
        
        model.todos = [todo2, todo1]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertTrue(model.isContainsTodoInGroups(index: 0))
            XCTAssertTrue(model.isContainsTodoInGroups(index: 1))
            XCTAssertFalse(model.isContainsTodoInGroups(index: 2))
        }
        
        model.todos = [todo1, todo2, todo3]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertTrue(model.isContainsTodoInGroups(index: 0))
            XCTAssertTrue(model.isContainsTodoInGroups(index: 1))
            XCTAssertTrue(model.isContainsTodoInGroups(index: 2))
        }
        
        model.todos = [todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isContainsTodoInGroups(index: 0))
            XCTAssertTrue(model.isContainsTodoInGroups(index: 1))
            XCTAssertFalse(model.isContainsTodoInGroups(index: 2))
        }
        
        model.todos = []
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isContainsTodoInGroups(index: 0))
            XCTAssertFalse(model.isContainsTodoInGroups(index: 1))
            XCTAssertFalse(model.isContainsTodoInGroups(index: 2))
        }
    }
    
    func test_isFinishedTodo() {
        let model = TodayTodoModelMock()
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: nil)
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user3", "user4"], profileImageURL: nil)
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        let todo3 = Todo(isFinished: true, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date()))
        model.groups = [group1, group2, group3]
        
        model.todos = [todo1, todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isFinishedTodo(index: 0))
            XCTAssertTrue(model.isFinishedTodo(index: 1))
            XCTAssertFalse(model.isFinishedTodo(index: 2))
        }
        
        model.todos = [todo3, todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isFinishedTodo(index: 0))
            XCTAssertTrue(model.isFinishedTodo(index: 1))
            XCTAssertTrue(model.isFinishedTodo(index: 2))
            
            XCTContext.runActivity(named: "isFinishedを変更した時も返り値が正しいこと") { _ in
                model.todos[0].isFinished = false
                model.todos[1].isFinished = false
                
                XCTAssertFalse(model.isFinishedTodo(index: 0))
                XCTAssertFalse(model.isFinishedTodo(index: 1))
                XCTAssertFalse(model.isFinishedTodo(index: 2))
            }
        }
        
        model.todos = [todo3, todo1, todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isFinishedTodo(index: 0))
            XCTAssertTrue(model.isFinishedTodo(index: 1))
            XCTAssertTrue(model.isFinishedTodo(index: 2))
        }
        
        model.todos = []
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertFalse(model.isFinishedTodo(index: 0))
            XCTAssertFalse(model.isFinishedTodo(index: 1))
            XCTAssertFalse(model.isFinishedTodo(index: 2))
        }
        
    }
    
    func test_getFinishedTodoIndex() {
        let model = TodayTodoModelMock()
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: nil)
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user3", "user4"], profileImageURL: nil)
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        let todo3 = Todo(isFinished: true, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date()))
        model.groups = [group1, group2, group3]
        
        model.todos = [todo1, todo2]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 0), 0)
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 1), 1)
            XCTAssertNil(model.getFinishedTodoIndex(groupIndex: 2))
        }
        
        model.todos = [todo3, todo1]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 0), 1)
            XCTAssertNil(model.getFinishedTodoIndex(groupIndex: 1))
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 2), 0)
        }
        
        model.todos = [todo2, todo3, todo1]
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 0), 2)
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 1), 0)
            XCTAssertEqual(model.getFinishedTodoIndex(groupIndex: 2), 1)
        }
        
        model.todos = []
        
        XCTContext.runActivity(named: "関数の返り値が正しいこと") { _ in
            XCTAssertNil(model.getFinishedTodoIndex(groupIndex: 0))
            XCTAssertNil(model.getFinishedTodoIndex(groupIndex: 1))
            XCTAssertNil(model.getFinishedTodoIndex(groupIndex: 2))
        }
    }
}
