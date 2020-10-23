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
            presenter.didTapCancelRemoveUser()
            XCTAssertNil(model.mayRemoveUserUID)
        }
    }
    
    func test_1人のユーザをremoveするとき() {
        let model = EditGroupModelMock()
        let presenter = EditGroupViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        let removeUser = User(id: "id3", name: "user3", profileImageURL: "u3")
        let groupUsersCount = presenter.groupUsers.count
        
        presenter.tapSelectedUsersAndMeProfileImage(index: 2)
        presenter.didTapRemoveUserAction()
        XCTAssertEqual(presenter.groupUsers.count, groupUsersCount - 1)
        XCTAssertFalse(presenter.groupUsers.contains(removeUser))
    }
    
    func test_自分以外のユーザ全てを順に削除するとき() {
        let model = EditGroupModelMock()
        let presenter = EditGroupViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        for tmp in (1 ..< presenter.groupUsers.count).reversed() {
            let randomNum = Int.random(in: 1 ... tmp) // 1からtmpまでどのユーザをタップするかを決める。なお0番目は自分だからタップしない
            let removeUser = presenter.groupUsers[randomNum]
            presenter.tapSelectedUsersAndMeProfileImage(index: randomNum)
            presenter.didTapRemoveUserAction()
            
            XCTAssertEqual(presenter.groupUsers.count, tmp)
            XCTAssertFalse(presenter.groupUsers.contains(removeUser))
        }
    }
    
    func test_2人目のユーザの削除をキャンセルするとき() {
        let model = EditGroupModelMock()
        let presenter = EditGroupViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        let removeUser = User(id: "id4", name: "user4", profileImageURL: "u4")
        let groupUsersCount = presenter.groupUsers.count
        
        presenter.tapSelectedUsersAndMeProfileImage(index: 3)
        XCTAssertEqual(model.mayRemoveUserUID, "id4")
        presenter.didTapRemoveUserAction()
        XCTAssertEqual(presenter.groupUsers.count, groupUsersCount - 1)
        XCTAssertFalse(presenter.groupUsers.contains(removeUser))
        
        let DontRemoveUser = User(id: "id2", name: "user2", profileImageURL: "u2")
        
        presenter.tapSelectedUsersAndMeProfileImage(index: 1)
        XCTAssertEqual(model.mayRemoveUserUID, "id2")
        presenter.didTapCancelRemoveUser()
        XCTAssertNil(model.mayRemoveUserUID)
        XCTAssertEqual(presenter.groupUsers.count, groupUsersCount - 1)
        XCTAssertFalse(presenter.groupUsers.contains(removeUser))
        XCTAssertTrue(presenter.groupUsers.contains(DontRemoveUser))
    }
}
