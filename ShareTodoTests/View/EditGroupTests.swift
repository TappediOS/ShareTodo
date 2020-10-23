//
//  EditGroupTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/10/23.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class EditGroupTests: XCTestCase {
    var view: EditGroupViewController!
    
    override func setUpWithError() throws {
        view = R.storyboard.editGroup().instantiateInitialViewController() as? EditGroupViewController
        guard self.view != nil else { return }
        
        let presenter = EditGroupViewPresenter(model: EditGroupModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
    }
    
    override func tearDownWithError() throws {
        view = nil
    }
    
    func test_VC表示時にTextFieldの文字が正しいこと() {
        let expectation = self.expectation(description: "expectation")
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.view.groupNameTextField.text, "Apple")
            XCTAssertEqual(self.view.taskTextField.text, "Pie")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_VC表示時にMembersCollectionViewにMemberが表示されること() {
        
    }
}
