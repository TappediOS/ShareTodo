//
//  ProfileViewTest.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/24.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class ProfileViewModelMock: ProfileModelProtocol {
    var presenter: ProfileModelOutput!
    
    func fetchUser() {
        let result = User(id: "123", name: "Rock", profileImageURL: nil)
        self.presenter.successFetchUser(user: result)
    }
    
    
}

class ProfileViewTest: XCTestCase {

    var view: ProfileViewController!
    
    override func setUpWithError() throws {
        view = R.storyboard.profile().instantiateInitialViewController() as? ProfileViewController
        guard view != nil else { return }
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_showUserNameAndImage() throws {
        let presenter = ProfileViewPresenter(model: ProfileViewModelMock())
        view.inject(with: presenter)
        
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        XCTAssertEqual(view.profileImageView.image, R.image.defaultProfileImage())
        XCTAssertEqual(view.nameLabel.text, "Rock")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
