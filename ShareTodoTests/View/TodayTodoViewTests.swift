//
//  TodayTodoViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/08.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo


class TodayTodoViewTests: XCTestCase {
    var view: TodayTodoViewController!
    
    override func setUpWithError() throws {
        view = R.storyboard.todayTodo().instantiateInitialViewController() as? TodayTodoViewController
        guard view != nil else { return }
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_起動時の変数の値が正しいこと() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertFalse(presenter.todos[0].isFinished)
            XCTAssertTrue(presenter.todos[1].isFinished)
        }
        XCTContext.runActivity(named: "sectionとrowの数が正しいこと") { _ in
            let sectionNum = view.numberOfSections(in: view.todayTodoCollectionView)
            XCTAssertEqual(sectionNum, 1)
            let rowNum = view.collectionView(view.todayTodoCollectionView, numberOfItemsInSection: 0)
            XCTAssertEqual(rowNum, presenter.numberOfGroups)
        }
    }
    
    func test_起動時のCellの値が正しいこと() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()

        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        guard let cell3 = cell_3 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "1つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell1.groupNameLabel.text, R.string.localizable.group_Colon() + "Apple")
            XCTAssertEqual(cell1.taskLabel.text, "Pie")
            XCTAssertNil(cell1.groupImageView.image)
        }
        XCTContext.runActivity(named: "2つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell2.groupNameLabel.text, R.string.localizable.group_Colon() + "Banana")
            XCTAssertEqual(cell2.taskLabel.text, "Juice")
            XCTAssertNil(cell2.groupImageView.image)
        }
        XCTContext.runActivity(named: "3つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell3.groupNameLabel.text, R.string.localizable.group_Colon() + "Grape")
            XCTAssertEqual(cell3.taskLabel.text, "Jelly")
            XCTAssertNil(cell3.groupImageView.image)
        }
    }
    
    func test_起動後に1つ目のcellをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didTapRadioButton(index: 0)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertTrue(presenter.todos[0].isFinished)
            XCTAssertTrue(presenter.todos[1].isFinished)
        }
    }
    
    func test_起動後に2つ目のcellをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didTapRadioButton(index: 1)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertFalse(presenter.todos[0].isFinished)
            XCTAssertFalse(presenter.todos[1].isFinished)
        }
    }
    
    func test_起動後に3つ目のcellをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didTapRadioButton(index: 2)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 3)
            XCTAssertFalse(presenter.todos[0].isFinished)
            XCTAssertTrue(presenter.todos[1].isFinished)
            XCTAssertTrue(presenter.todos[2].isFinished)
        }
    }
    
    func test_起動後に複数のcellをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didTapRadioButton(index: 0)
        presenter.didTapRadioButton(index: 1)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertTrue(presenter.todos[0].isFinished)
            XCTAssertFalse(presenter.todos[1].isFinished)
        }
        
        presenter.didTapRadioButton(index: 2)
        presenter.didTapRadioButton(index: 0)
        presenter.didTapRadioButton(index: 2)
        
        XCTContext.runActivity(named: "todosの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 3)
            XCTAssertFalse(presenter.todos[0].isFinished)
            XCTAssertFalse(presenter.todos[1].isFinished)
            XCTAssertFalse(presenter.todos[2].isFinished)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
