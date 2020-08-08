//
//  TodayTodoViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/08.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

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
