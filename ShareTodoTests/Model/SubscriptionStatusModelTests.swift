//
//  SubscriptionStatusModelTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class SubscriptionStatusModelTests: XCTestCase {
    var model: SubscriptionStatusModel!

    override func setUpWithError() throws {
        self.model = SubscriptionStatusModel()
        guard self.model != nil else { return }
    }

    override func tearDownWithError() throws {
        self.model = nil
    }

    func testConvertDateToString() {
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
