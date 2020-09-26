//
//  UserDetailViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class UserDetailViewTests: XCTestCase {
    var view: UserDetailViewController!
    
    override func setUpWithError() throws {
        view = R.storyboard.userDetail().instantiateInitialViewController() as? UserDetailViewController
        guard view != nil else { return }
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_表示時に変数の値が正しいこと() {
        let expectation = self.expectation(description: "expectation")
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        DispatchQueue.main.async {
            XCTAssertEqual(self.view.groupNameLabel.text, "Apple")
            XCTAssertEqual(self.view.groupTaskLabel.text, "Pie")
            XCTAssertNil(self.view.groupImageView.image)
            XCTAssertNil(self.view.profileImageView.image)
            XCTAssertNotNil(self.view.profileImageView)
            XCTAssertEqual(self.view.navigationItem.title, "Joe")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
   
}
