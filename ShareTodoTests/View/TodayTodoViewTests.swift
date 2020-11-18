//
//  TodayTodoViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/08.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class TodayTodoViewTests: XCTestCase {
    var view: TodayTodoViewController!
    
    private let checkmarkNotFillImage = UIImage(systemName: "checkmark.circle")
    private let checkmarkFillImage = UIImage(systemName: "checkmark.circle.fill")
    private let pencilFillImage = UIImage(systemName: "pencil.circle.fill")
    private let pencilNotFillImage = UIImage(systemName: "pencil.circle")
    
    override func setUpWithError() throws {
        view = R.storyboard.todayTodo().instantiateInitialViewController() as? TodayTodoViewController
        guard view != nil else { return }
    }

    override func tearDownWithError() throws { }
    
    func test_起動時のcollectionViewのsettionとrawが正しいこと() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        XCTContext.runActivity(named: "sectionとrowの数が正しいこと") { _ in
            let sectionNum = view.numberOfSections(in: view.todayTodoCollectionView)
            XCTAssertEqual(sectionNum, 1)
            let rowNum = view.collectionView(view.todayTodoCollectionView, numberOfItemsInSection: 0)
            XCTAssertEqual(rowNum, presenter.numberOfGroups)
        }
    }
    
    func test_起動時のisFinishedの値が正しいこと() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        XCTContext.runActivity(named: "isFinishedの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertFalse(presenter.todos[0].isFinished)
            XCTAssertTrue(presenter.todos[1].isFinished)
        }
    }
    
    func test_起動時のmessageの値が正しいこと() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        XCTContext.runActivity(named: "messageの状態が正しいこと") { _ in
            XCTAssertEqual(presenter.todos.count, 2)
            XCTAssertNil(presenter.todos[0].message)
            XCTAssertEqual(presenter.todos[1].message, "Hello World")
        }
    }
    
    func test_起動時のCellの値が正しいこと_サブスク登録している場合() {
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
        
        // NOTE:- サブスク登録して`いる`ことに注意して`writeMessageButton.isHidden`をAssertする
        //        todo1.isFinished = false, todo2.isFinished = true, todo3.isFinished = false
        XCTContext.runActivity(named: "1つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell1.groupNameLabel.text, R.string.localizable.group_Colon() + "Apple")
            XCTAssertEqual(cell1.taskLabel.text, "Pie")
            XCTAssertNil(cell1.groupImageView.image)
            XCTAssertTrue(cell1.writeMessageButton.isHidden)
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkNotFillImage)
            XCTAssertEqual(cell1.writeMessageButton.imageView?.image, self.pencilNotFillImage)
        }
        XCTContext.runActivity(named: "2つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell2.groupNameLabel.text, R.string.localizable.group_Colon() + "Banana")
            XCTAssertEqual(cell2.taskLabel.text, "Juice")
            XCTAssertNil(cell2.groupImageView.image)
            XCTAssertFalse(cell2.writeMessageButton.isHidden)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.writeMessageButton.imageView?.image, self.pencilFillImage)
        }
        XCTContext.runActivity(named: "3つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell3.groupNameLabel.text, R.string.localizable.group_Colon() + "Grape")
            XCTAssertEqual(cell3.taskLabel.text, "Jelly")
            XCTAssertNil(cell3.groupImageView.image)
            XCTAssertTrue(cell3.writeMessageButton.isHidden)
            XCTAssertEqual(cell3.radioButton.imageView?.image, self.checkmarkNotFillImage)
            XCTAssertEqual(cell3.writeMessageButton.imageView?.image, self.pencilNotFillImage)
        }
    }
    
    func test_起動時のCellの値が正しいこと_サブスク登録していない場合() {
        let model = TodayTodoModelMock()
        let presenter = TodayTodoViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        // サブスクをfalseにする
        model.changeUserSubscribedIsFalse()

        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        guard let cell3 = cell_3 as? TodayTodoCollectionViewCell else { return }
        
        // NOTE:- サブスク登録して`いない`ことに注意して`writeMessageButton.isHidden`をAssertする
        XCTContext.runActivity(named: "1つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell1.groupNameLabel.text, R.string.localizable.group_Colon() + "Apple")
            XCTAssertEqual(cell1.taskLabel.text, "Pie")
            XCTAssertNil(cell1.groupImageView.image)
            XCTAssertTrue(cell1.writeMessageButton.isHidden)
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkNotFillImage)
        }
        XCTContext.runActivity(named: "2つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell2.groupNameLabel.text, R.string.localizable.group_Colon() + "Banana")
            XCTAssertEqual(cell2.taskLabel.text, "Juice")
            XCTAssertNil(cell2.groupImageView.image)
            XCTAssertTrue(cell2.writeMessageButton.isHidden)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
        }
        XCTContext.runActivity(named: "3つ目のcellの情報が正しいこと") { _ in
            XCTAssertEqual(cell3.groupNameLabel.text, R.string.localizable.group_Colon() + "Grape")
            XCTAssertEqual(cell3.taskLabel.text, "Jelly")
            XCTAssertNil(cell3.groupImageView.image)
            XCTAssertTrue(cell3.writeMessageButton.isHidden)
            XCTAssertEqual(cell3.radioButton.imageView?.image, self.checkmarkNotFillImage)
        }
    }
    
    func test_起動後に1つ目のcellのradioButtonをタップしたときのテスト() {
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
        
        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "1つ目のwriteMessageButtonが表示されているかどうか") { _ in
            XCTAssertFalse(cell1.writeMessageButton.isHidden)
        }
        XCTContext.runActivity(named: "1つ目のcellのradioButtonがcheckmarkFillになってるかどうか") { _ in
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkFillImage)
        }
        XCTContext.runActivity(named: "1つ目のcellのwriteMessageButtonがpenceilNotFillであるかどうか") { _ in
            XCTAssertEqual(cell1.writeMessageButton.imageView?.image, self.pencilNotFillImage)
        }
    }
    
    func test_起動後に2つ目のcellのradioButtonをタップしたときのテスト() {
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
    
    func test_起動後に3つ目のcellのradioButtonをタップしたときのテスト() {
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
    
    func test_起動後に複数のcellのradioButtonをタップしたときのテスト() {
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
    
    // NOTE:- 1つ目のmessageはnilであるので先にRadioButtonをタップする
    func test_起動後に1つ目のcellのwriteMessageButtonをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didTapRadioButton(index: 0)
        presenter.didEndAddMessage(message: "nil to i am apple!", index: 0)
        
        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "writeMessageButtonが表示されてるかどうか") { _ in
            XCTAssertTrue(presenter.isWrittenMessage(index: 0))
            XCTAssertTrue(presenter.isWrittenMessage(index: 1))
            XCTAssertFalse(cell1.writeMessageButton.isHidden)
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell1.writeMessageButton.imageView?.image, self.pencilFillImage)
            XCTAssertEqual(presenter.todos[0].message, "nil to i am apple!")
        }
    }
    
    func test_起動後に2つ目のcellのwriteMessageButtonをタップしたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didEndAddMessage(message: "Hello World to My World", index: 1)
        
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "writeMessageButtonが表示されてるかどうか") { _ in
            XCTAssertFalse(presenter.isWrittenMessage(index: 0))
            XCTAssertTrue(presenter.isWrittenMessage(index: 1))
            XCTAssertFalse(cell2.writeMessageButton.isHidden)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.writeMessageButton.imageView?.image, self.pencilFillImage)
            XCTAssertEqual(presenter.todos[1].message, "Hello World to My World")
        }
    }
    
    func test_起動後に2つ目のcellのwriteMessageButtonをタップして，もう一回そのボタンを押したたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didEndAddMessage(message: "Hello World to My World", index: 1)
        presenter.didTapWriteMessageButtonAction(index: 1)
        
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "radioはtrue, messageのisHiddenはfalse, radioButton.imageはFill, messageはnil") { _ in
            XCTAssertTrue(presenter.todos[1].isFinished)
            XCTAssertFalse(cell2.writeMessageButton.isHidden)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.writeMessageButton.imageView?.image, self.pencilNotFillImage)
            XCTAssertEqual(presenter.todos[1].message, nil)
        }
    }
    
   func test_起動後に2つ目のcellのwriteMessageButtonをタップして，その後にradioButtonを押したたときのテスト() {
        let presenter = TodayTodoViewPresenter(model: TodayTodoModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        presenter.didEndAddMessage(message: "Hello World to My World", index: 1)
        presenter.didTapRadioButton(index: 1)
        
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "radioはfalse, messageのisHiddenはtrue, radioButton.imageはNotFill, messageはnil") { _ in
            XCTAssertFalse(presenter.todos[1].isFinished)
            XCTAssertTrue(cell2.writeMessageButton.isHidden)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkNotFillImage)
            XCTAssertEqual(cell2.writeMessageButton.imageView?.image, self.pencilNotFillImage)
            XCTAssertEqual(presenter.todos[1].message, nil)
        }
    }
    
    func test_サブスク登録してない場合はradioButtonを押してTodo完了させてもwriteMessageButtonが表示されないこと() {
        let model = TodayTodoModelMock()
        let presenter = TodayTodoViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        model.changeUserSubscribedIsFalse()
        
        // cell1.isFinished = true, cell1.isFinished = true, cell3.isFinished = false
        presenter.didTapRadioButton(index: 0)
        
        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        guard let cell3 = cell_3 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "writeMessageButtonのisHiddenはtrueである") { _ in
            XCTAssertTrue(cell1.writeMessageButton.isHidden)
            XCTAssertTrue(cell2.writeMessageButton.isHidden)
            XCTAssertTrue(cell3.writeMessageButton.isHidden)
            
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell3.radioButton.imageView?.image, self.checkmarkNotFillImage)
        }
    }
    
    func test_サブスク登録の登録が開始された場合にwriteMessageButtonが表示されること() {
        let model = TodayTodoModelMock()
        let presenter = TodayTodoViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        // サブスクはfalseで始める
        model.changeUserSubscribedIsFalse()
        
        // 0番目のセルをタップした時点で以下のようになる
        // cell1.isFinished = true, cell1.isFinished = true, cell3.isFinished = false
        presenter.didTapRadioButton(index: 0)
        
        //ここでサブスク登録した通知を発行する
        model.startSubscribed()
        
        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        guard let cell3 = cell_3 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "writeMessageButtonのisHiddenはfalseである") { _ in
            XCTAssertFalse(cell1.writeMessageButton.isHidden)
            XCTAssertFalse(cell2.writeMessageButton.isHidden)
            XCTAssertTrue(cell3.writeMessageButton.isHidden) // 3つ目のcellのisFinishedはfalseなのでwriteMessageButtonは表示されない

        }
        XCTContext.runActivity(named: "writeMessageButtonとradioButtonに正しい画像がセットされている") { _ in
            XCTAssertEqual(cell1.writeMessageButton.imageView?.image, self.pencilNotFillImage)
            XCTAssertEqual(cell2.writeMessageButton.imageView?.image, self.pencilFillImage) // この子だけすでにmessage登録されてるからfillImage
            XCTAssertEqual(cell3.writeMessageButton.imageView?.image, self.pencilNotFillImage)
            
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell3.radioButton.imageView?.image, self.checkmarkNotFillImage)
        }
    }
    
    func test_サブスク登録が切れた場合の表示テスト() {
        let model = TodayTodoModelMock()
        let presenter = TodayTodoViewPresenter(model: model)
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        // 0番目のセルをタップした時点で以下のようになる
        // cell1.isFinished = true, cell1.isFinished = true, cell3.isFinished = false
        presenter.didTapRadioButton(index: 0)
        
        //ここでサブスク登録が切れたした通知を発行する
        model.endSubscribed()
        model.changeUserSubscribedIsFalse()
        
        let cell_1 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 0, section: 1))
        let cell_2 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 1, section: 1))
        let cell_3 = view.collectionView(view.todayTodoCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        guard let cell1 = cell_1 as? TodayTodoCollectionViewCell else { return }
        guard let cell2 = cell_2 as? TodayTodoCollectionViewCell else { return }
        guard let cell3 = cell_3 as? TodayTodoCollectionViewCell else { return }
        
        XCTContext.runActivity(named: "writeMessageButtonのisHiddenはtrueである") { _ in
            XCTAssertTrue(cell1.writeMessageButton.isHidden)
            XCTAssertTrue(cell2.writeMessageButton.isHidden)
            XCTAssertTrue(cell3.writeMessageButton.isHidden)
        }
        XCTContext.runActivity(named: "radioButtonに正しい画像がセットされている") { _ in
            XCTAssertEqual(cell1.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell2.radioButton.imageView?.image, self.checkmarkFillImage)
            XCTAssertEqual(cell3.radioButton.imageView?.image, self.checkmarkNotFillImage)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
