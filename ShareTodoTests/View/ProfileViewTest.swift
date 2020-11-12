//
//  ProfileViewTest.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/24.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class ProfileViewTest: XCTestCase {
    var view: ProfileViewController!
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    override func setUpWithError() throws {
        view = R.storyboard.profile().instantiateInitialViewController() as? ProfileViewController
        guard view != nil else { return }
        self.delegate = view
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_起動時にUIの状態が正しいこと() {
        let presenter = ProfileViewPresenter(model: ProfileViewModelMock())
        view.inject(with: presenter)
        
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        XCTAssertTrue(view.scrollView.alwaysBounceVertical)
        XCTAssertEqual(view.profileImageView.layer.cornerRadius, view.profileImageView.frame.width / 2)
    }

    func test_表示時にラベルの情報が正しいこと() throws {
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
