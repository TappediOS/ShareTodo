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
    }
    
    override func tearDownWithError() throws {
        view = nil
    }
    
    func test_VC表示時にTextFieldの文字が正しいこと() {
        let expectation = self.expectation(description: "expectation")
        let presenter = EditGroupViewPresenter(model: EditGroupModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.view.groupNameTextField.text, "Apple")
            XCTAssertEqual(self.view.taskTextField.text, "Pie")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_VC表示時にMembersCollectionViewにMemberが表示されること() {
        let presenter = EditGroupViewPresenter(model: EditGroupModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        let cell_1 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        let cell_4 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 3, section: 1))
        let cell_5 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 4, section: 1))
        let cell_6 = view.collectionView(view.selectedUsersAndMeCollectionView, cellForItemAt: IndexPath(row: 5, section: 1))
        
        guard let cell1 = cell_1 as? SelectedUsersAndMeCollectionViewCell else { return }
        guard let cell2 = cell_2 as? SelectedUsersAndMeCollectionViewCell else { return }
        guard let cell3 = cell_3 as? SelectedUsersAndMeCollectionViewCell else { return }
        guard let cell4 = cell_4 as? SelectedUsersAndMeCollectionViewCell else { return }
        guard let cell5 = cell_5 as? SelectedUsersAndMeCollectionViewCell else { return }
        guard let cell6 = cell_6 as? SelectedUsersAndMeCollectionViewCell else { return }
        
        XCTAssertEqual(cell1.nameLabel.text, "user1")
        XCTAssertEqual(cell2.nameLabel.text, "user2")
        XCTAssertEqual(cell3.nameLabel.text, "user3")
        XCTAssertEqual(cell4.nameLabel.text, "user4")
        XCTAssertEqual(cell5.nameLabel.text, "user5")
        XCTAssertEqual(cell6.nameLabel.text, "user6")
    }
    
    func test_collectionViewの自分自身のcellをタップしたとき() {
        let model = EditGroupModelMock()
        let presenter = EditGroupViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.tapSelectedUsersAndMeProfileImage(index: 0)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertNil(model.mayRemoveUserUID)
        }
    }
    
    func test_collectionViewの自分以下のcellをタップしたとき() {
        let model = EditGroupModelMock()
        let presenter = EditGroupViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        for tmp in 1 ..< presenter.groupUsers.count {
            presenter.tapSelectedUsersAndMeProfileImage(index: tmp)
            XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
                XCTAssertNotNil(model.mayRemoveUserUID)
            }
        }
    }
}
