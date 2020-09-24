//
//  TodayTodoModelTest.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/24.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
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
}
