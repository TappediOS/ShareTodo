//
//  TodayTodoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol TodayTodoViewPresenterProtocol {
    var view: TodayTodoViewPresenterOutput! { get set }
    var numberOfGroups: Int { get }
    var groups: [Group] { get }
    var todos: [Todo] { get }
    var isUserSubscribed: Bool { get }
    
    func didViewDidLoad()
    func didViewWillAppear()
    func didTapRadioButton(index: Int)
    func didTapWriteMessageButtonAction(index: Int)
    func didTapEmptyDataSetButton()
    func didAllowNotification()
    
    func didEndAddMessage(message: String?, index: Int)
    
    func isFinishedTodo(index: Int) -> Bool
    func isWrittenMessage(index: Int) -> Bool
}

protocol TodayTodoViewPresenterOutput: class {
    func showAddMessageEditView(index: Int)
    
    func reloadTodayTodoCollectionView()
    func setDZEmptyDataSetDelegate()
    func showRequestAllowNotificationView()
    func showCreateGroupInfoVC()
    
    func showSKStoreReviewController()
    
    func startActivityIndicator()
    func stopActivityIndicator()
    
    func showErrorAleartView(error: Error)
    
    func impactFeedbackOccurred_light()
    func impactFeedbackOccurred_medium()
    func impactFeedbackOccurred_heavy()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class TodayTodoViewPresenter: TodayTodoViewPresenterProtocol, TodayTodoModelOutput {
    weak var view: TodayTodoViewPresenterOutput!
    private var model: TodayTodoModelProtocol
    
    var numberOfGroups: Int { return self.model.groups.count }
    var groups: [Group] { return self.model.groups }
    var todos: [Todo] { return self.model.todos }
    var isUserSubscribed: Bool { return self.model.isUserSubscribed }
    
    init(model: TodayTodoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        if self.model.isFirstOpen() { self.view.showRequestAllowNotificationView() }
        self.view.startActivityIndicator()
        self.model.fetchGroups()
        self.model.checkingIfAUserSubscribed()
        
        self.model.countUpOpenApp()
        if self.model.shouldRequestStoreReviewOpenAppCount() { self.view.showSKStoreReviewController() }
    }
    
    func didViewWillAppear() {
        // viewWillAppearが呼ばれるときはsubscをcheckする
        self.model.checkingIfAUserSubscribed()
    }
    
    func successFetchTodayTodo() {
        self.view.setDZEmptyDataSetDelegate()
        self.view.reloadTodayTodoCollectionView()
        self.view.stopActivityIndicator()
    }
    
    func successUnfinishedTodo() {
        self.view.reloadTodayTodoCollectionView()
        self.view.impactFeedbackOccurred_medium()
    }
    
    func successFinishedTodo() {
        self.model.fetchGroups()
        self.view.stopActivityIndicator()
        self.view.impactFeedbackOccurred_heavy()
        
        self.model.countUpRequestFinishTodo()
        if self.model.shouldRequestStoreReviewFinishTodoCount() { self.view.showSKStoreReviewController() }
    }
    
    func didTapRadioButton(index: Int) {
        if self.model.isFinishedTodo(index: index) {
            self.model.unfinishedTodo(index: index)
            return
        }
        
        self.model.finishedTodo(index: index)
    }
    
    func didTapWriteMessageButtonAction(index: Int) {
        guard self.model.isWrittenMessage(index: index) else {
            self.view.showAddMessageEditView(index: index)
            self.view.impactFeedbackOccurred_light()
            return
        }
        
        self.model.cancelMessage(index: index)
    }
    
    func didTapEmptyDataSetButton() {
        self.view.showCreateGroupInfoVC()
        self.view.impactFeedbackOccurred_light()
    }
    
    func didAllowNotification() {
        self.model.setFcmToken()
    }
    
    func didEndAddMessage(message: String?, index: Int) {
        guard let message = message else { return }
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        self.model.writeMessage(message: message, index: index)
    }
    
    func successWriteMessage() {
        self.view.reloadTodayTodoCollectionView()
        self.view.impactFeedbackOccurred_heavy()
    }
    
    func successCancelMessage() {
        self.view.reloadTodayTodoCollectionView()
        self.view.impactFeedbackOccurred_medium()
    }
    
    func isFinishedTodo(index: Int) -> Bool {
        return self.model.isFinishedTodo(index: index)
    }
    
    func isWrittenMessage(index: Int) -> Bool {
        return self.model.isWrittenMessage(index: index)
    }
    
    func userSubscribed() {
        self.view.reloadTodayTodoCollectionView()
    }
    
    func userStartSubscribed() {
        self.model.checkingIfAUserSubscribed()
    }
    
    func userEndSubscribed() {
        self.view.reloadTodayTodoCollectionView()
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
        self.view.noticeFeedbackOccurredError()
    }
}
