//
//  UserDetailViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol UserDetailViewPresenterProtocol {
    var view: UserDetailViewPresenterOutput! { get set }
    var group: Group { get }
    var user: User { get }
    var todoList: [Todo] { get }
    var isUserSubscribed: Bool { get }
    
    func didViewDidLoad()
    func didViewWillAppear()
    func didTapIntroductionButton()
    func didScrollViewDidScroll(height: Double)
    
    func getTheDayIsAWeekAgo(date: Date) -> Bool
    func getContaintFinishedDate(date: Date) -> Bool
    
    func getMinimumDate() -> Date
}

protocol UserDetailViewPresenterOutput: class {
    func setUserName()
    func setGroupName()
    func setGroupTask()
    func setProfileImage(_ url: URL)
    func setGroupImage(_ url: URL)
    func reloadCalenderView()
    func moveAndResizeImage(scale: Double, xTranslation: Double, yTranslation: Double)
    
    func segueIntroductionShareTodoPlusVC()
}

final class UserDetailViewPresenter: UserDetailViewPresenterProtocol, UserDetailModelOutput {
    weak var view: UserDetailViewPresenterOutput!
    private var model: UserDetailModelProtocol
    
    var group: Group { return self.model.group }
    var user: User { return self.model.user }
    var todoList: [Todo] { return self.model.todos }
    
    var isUserSubscribed: Bool { return self.model.isUserSubscribed }
    
    init(model: UserDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchTodoList()
        self.model.checkingIfAUserSubscribed()
        self.view.setGroupName()
        self.view.setGroupTask()
        if let profileImageURL = URL(string: self.user.profileImageURL ?? "") { self.view.setProfileImage(profileImageURL) }
        if let groupImageURL = URL(string: self.group.profileImageURL ?? "") { self.view.setGroupImage(groupImageURL) }
        
    }
    
    func didViewWillAppear() {
        // viewWillAppearが呼ばれるときはsubscをcheckする
        self.model.checkingIfAUserSubscribed()
    }
    
    func didTapIntroductionButton() {
        self.view.segueIntroductionShareTodoPlusVC()
    }
    
    func didScrollViewDidScroll(height: Double) {
        let result = self.model.calculateForNavigationImage(height: height)
        self.view.moveAndResizeImage(scale: result.scale, xTranslation: result.xTranslation, yTranslation: result.yTranslation)
    }
    
    func getTheDayIsAWeekAgo(date: Date) -> Bool {
        return self.model.isTheDayAWeekAgo(date: date)
    }
    
    func getContaintFinishedDate(date: Date) -> Bool {
        return self.model.getContaintFinishedDate(date: date)
    }
    
    func getMinimumDate() -> Date {
        return self.model.getMinimumDate()
    }
    
    func successFetchTodoList() {
        self.view.reloadCalenderView()
    }
    
    func userSubscribed() {
        self.view.reloadCalenderView()
    }
    
    func userStartSubscribed() {
        self.model.checkingIfAUserSubscribed()
    }
    
    func userEndSubscribed() {
        self.model.checkingIfAUserSubscribed()
    }
}
