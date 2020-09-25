//
//  UserDetailModelTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo
import FirebaseFirestore

class UserDetailModelTests: XCTestCase {
    let model = UserDetailModelMock()
    
    override func setUpWithError() throws {
        self.appendTodo()
    }
    
    override func tearDownWithError() throws {

    }
    
    func appendTodo() {
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
        self.model.todos = [todo1, todo2, todo3, todo4, todo5, todo6, todo7, todo8, todo9]
    }
    
    func test_isTheDayAWeekAgo() {
        XCTContext.runActivity(named: "今日から1週間まではTrueである") { _ in
            for tmp in 0 ... 6 {
                XCTAssertTrue(model.isTheDayAWeekAgo(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * Double(tmp))))
            }
        }
        
        XCTContext.runActivity(named: "1週間以降はFalseである") { _ in
            for tmp in 7 ... 30 * 12 * 10 {
                XCTAssertFalse(model.isTheDayAWeekAgo(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * Double(tmp))))
            }
        }
        
        XCTContext.runActivity(named: "今日以降はFalseである") { _ in
            for tmp in 1 ... 30 * 12 * 10 {
                XCTAssertFalse(model.isTheDayAWeekAgo(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * Double(tmp))))
            }
        }
    }
    
    func test_getTodoListAsFinishedDate() {
        let str1 = model.dateFormatter.string(from: Date(timeIntervalSinceNow: -60*60*24*2))
        let str2 = model.dateFormatter.string(from: Date(timeIntervalSinceNow: -60*60*24*4))
        let str3 = model.dateFormatter.string(from: Date(timeIntervalSinceNow: -60*60*24*5))
        let str4 = model.dateFormatter.string(from: Date(timeIntervalSinceNow: -60*60*24*7))
        let exp = [str1, str2, str3, str4]
        
        XCTAssertEqual(self.model.getTodoListAsFinishedDate(), exp)
    }
    
    
    func testPerformanceExample() throws {
        self.measure {
            for tmp in 0 ... 10000 {
                _ = model.isTheDayAWeekAgo(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * Double(tmp)))
            }
        }
    }
    
}
