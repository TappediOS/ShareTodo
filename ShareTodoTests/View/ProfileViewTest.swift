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
    var navigationController: UINavigationController!
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    override func setUpWithError() throws {
        view = R.storyboard.profile().instantiateInitialViewController() as? ProfileViewController
        guard view != nil else { return }
        self.delegate = view
        
        navigationController = UINavigationController(rootViewController: view)
    }

    override func tearDownWithError() throws {
        self.view = nil
        self.navigationController = nil
        self.delegate = nil
    }
    
    func test_起動時にUIの状態が正しいこと() {
        let presenter = ProfileViewPresenter(model: ProfileViewModelMock())
        view.inject(with: presenter)
        
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        XCTAssertTrue(view.scrollView.alwaysBounceVertical)
        XCTAssertEqual(view.profileImageView.layer.cornerRadius, view.profileImageView.frame.width / 2)
    }

    func test_表示時に名前ラベルの情報が正しいこと() throws {
        let presenter = ProfileViewPresenter(model: ProfileViewModelMock())
        view.inject(with: presenter)
        
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        XCTAssertEqual(view.profileImageView.image, R.image.defaultProfileImage())
        XCTAssertEqual(view.nameLabel.text, "Rock")
    }
    
    func test_サブスクに登録しているときにplanLabelの状態が正しいこと() {
        let model = ProfileViewModelMock()
        let presenter = ProfileViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        model.checkingIfAUserSubscribed()
        XCTAssertEqual(view.planStatusLabel.text, R.string.localizable.premiunPlan())
    }
    
    func test_サブスクに登録してないときにplanLabelの状態が正しいこと() {
        let model = ProfileViewModelMock()
        let presenter = ProfileViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        model.checkingIfAUserSubscribed()
        model.changeSubscriptionFalse()
        XCTAssertEqual(view.planStatusLabel.text, R.string.localizable.freePlan())
    }
    
    func test_サブスクに登録しているときにStatusボタンを押しても画面遷移しないこと() {
        let model = ProfileViewModelMock()
        let presenter = ProfileViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        model.checkingIfAUserSubscribed()
        presenter.didTapPlanStateButton()
        
        if (view.navigationController?.topViewController as? ProfileViewController) == nil {
            XCTFail("課金してるのに画面遷移されている")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
