//
//  TodayTodoViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/08.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo
import Firebase

class TodayTodoModelMock: TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput!
    var groups: [Group] = Array()
    var todos: [Todo] = Array()
    
    func fetchGroups() {
        let group1 = Group(groupID: "group1", name: "Apple", task: "Pie", members: ["user1", "user2"], profileImageURL: nil)
        let group2 = Group(groupID: "group2", name: "Banana", task: "Juice", members: ["user1", "user3"], profileImageURL: nil)
        let group3 = Group(groupID: "group3", name: "Grape", task: "Jelly", members: ["user2", "user3", "user4"], profileImageURL: nil)
        
        self.groups = [group1, group2, group3]
        self.fetchTodayTodo(groupDocuments: [], userID: "user1")
    }
    
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String) {
        let todo1 = Todo(isFinished: false, userID: "user1", groupID: "group1", createdAt: Timestamp(date: Date()))
        let todo2 = Todo(isFinished: true, userID: "user1", groupID: "group2", createdAt: Timestamp(date: Date()))
        
        self.todos = [todo1, todo2]
        self.presenter.successFetchTodayTodo()
    }
    
    func isFirstOpen() -> Bool {
        return false
    }
    
    func isContainsTodoInGroups(index: Int) -> Bool {
        let group = groups[index]
        return !self.todos.filter({ $0.groupID == group.groupID ?? ""}).isEmpty
    }
    
    func isFinishedTodo(index: Int) -> Bool {
        guard isContainsTodoInGroups(index: index) else { return false }
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        
        if let todo = todo { return todo.isFinished }
        return false
        
    }
    
    func getFinishedTodoIndex(groupIndex: Int) -> Int? {
        for tmp in 0 ..< todos.count {
            if self.todos[tmp].groupID == self.groups[groupIndex].groupID ?? "" { return tmp }
        }
        return nil
    }
    
    func unfinishedTodo(index: Int) {
        guard let finishedTodoIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        self.todos[finishedTodoIndex].isFinished = false
        self.presenter.successUnfinishedTodo()
    }
    
    func finishedTodo(index: Int) {
        if index == 2 {
            self.todos.append(Todo(isFinished: true, userID: "user1", groupID: "group3", createdAt: Timestamp(date: Date())))
            return
        }
        self.todos[index].isFinished = true
    }
}

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
            XCTAssertEqual(cell1.groupNameLabel.text, "Group: Apple")
            XCTAssertEqual(cell1.taskLabel.text, "Pie")
            XCTAssertNil(cell1.groupImageView.image)
        }
        XCTContext.runActivity(named: "2つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell2.groupNameLabel.text, "Group: Banana")
            XCTAssertEqual(cell2.taskLabel.text, "Juice")
            XCTAssertNil(cell2.groupImageView.image)
        }
        XCTContext.runActivity(named: "3つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell3.groupNameLabel.text, "Group: Grape")
            XCTAssertEqual(cell3.taskLabel.text, "Jelly")
            XCTAssertNil(cell3.groupImageView.image)
        }
    }
    
    func testGetTodayFormat() throws {
        let todayTodoModel = TodayTodoModel()
        let exp = todayTodoModel.getTodayFormat()
        let expArray = exp.components(separatedBy: "_")
                
        XCTAssertEqual(expArray.count, 3)
        XCTAssertEqual(expArray[0].map { String($0) }.count, 4)
        XCTAssertEqual(expArray[1].map { String($0) }.count, 2)
        XCTAssertEqual(expArray[2].map { String($0) }.count, 2)
        
        let year = Int(expArray[0])!
        let month = Int(expArray[1])!
        let day = Int(expArray[2])!
        
        XCTAssertGreaterThanOrEqual(year, 2020)
        
        XCTAssertGreaterThanOrEqual(month, 1)
        XCTAssertLessThanOrEqual(month, 12)
        
        XCTAssertGreaterThanOrEqual(day, 1)
        XCTAssertLessThanOrEqual(day, 31)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
