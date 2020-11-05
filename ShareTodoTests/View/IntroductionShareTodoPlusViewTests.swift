//
//  IntroductionShareTodoPlusViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/11/05.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class IntroductionShareTodoPlusViewTests: XCTestCase {
    var view: IntroductionShareTodoPlusViewController!
    
    override func setUpWithError() throws {
        view = R.storyboard.introductionShareTodoPlus().instantiateInitialViewController() as? IntroductionShareTodoPlusViewController
        guard self.view != nil else { return }
    }
    
    override func tearDownWithError() throws {
        view = nil
    }

    //TODO:- 課金の処理を書いたらそのロジックに対してテストを追加すること
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
