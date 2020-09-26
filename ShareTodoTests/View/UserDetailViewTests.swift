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
    
    func test_viewを閉じたときにprofileImageViewがnavigationBarから削除されていること() {
        let expectation = self.expectation(description: "expectation")
        let parentVC = UIViewController()
        let parentViewController = UINavigationController(rootViewController: parentVC)
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        window?.rootViewController = parentViewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            parentVC.navigationController?.pushViewController(self.view, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                //表示されたときはcontaintsされている
                XCTAssertTrue(((self.view.navigationController?.navigationBar.subviews.contains(self.view.profileImageView)) != nil))
                XCTAssertTrue(((parentVC.navigationController?.navigationBar.subviews.contains(self.view.profileImageView)) != nil))
                self.view.navigationController?.popViewController(animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    //dismiss後は存在していない
                    let exp: Bool = (parentVC.navigationController?.navigationBar.subviews.contains(self.view.profileImageView))!
                    XCTAssertFalse(exp)
                    expectation.fulfill()
                })
            })
        })
        
        wait(for: [expectation], timeout: 3.0)
        
    }
}
