//
//  UserDetailModelTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class UserDetailModelTests: XCTestCase {
    let model = UserDetailModelMock()
    
    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {

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
    
    
    func testPerformanceExample() throws {
        self.measure {
            for tmp in 0 ... 10000 {
                _ = model.isTheDayAWeekAgo(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * Double(tmp)))
            }
        }
    }
    
}
