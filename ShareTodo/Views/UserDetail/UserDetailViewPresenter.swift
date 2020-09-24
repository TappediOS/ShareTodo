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
    
    func didViewDidLoad()
    func didTapIntroductionButton()
    func didScrollViewDidScroll(height: Double)
}

protocol UserDetailViewPresenterOutput: class {
    func setUserName()
    func setGroupName()
    func setGroupTask()
    func setProfileImage(_ url: URL)
    func setGroupImage(_ url: URL)
    func moveAndResizeImage(scale: Double, xTranslation: Double, yTranslation: Double)
    
    func segueIntroductionShareTodoPlusVC()
}

final class UserDetailViewPresenter: UserDetailViewPresenterProtocol, UserDetailModelOutput {
    weak var view: UserDetailViewPresenterOutput!
    private var model: UserDetailModelProtocol
    
    var group: Group { return self.model.group }
    var user: User { return self.model.user }
    
    init(model: UserDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.view.setGroupName()
        self.view.setGroupTask()
        if let profileImageURL = URL(string: self.user.profileImageURL ?? "") { self.view.setProfileImage(profileImageURL) }
        if let groupImageURL = URL(string: self.group.profileImageURL ?? "") { self.view.setGroupImage(groupImageURL) }
        
    }
    
    func didTapIntroductionButton() {
        self.view.segueIntroductionShareTodoPlusVC()
    }
    
    func didScrollViewDidScroll(height: Double) {
        let result = self.model.calculateForNavigationImage(height: height)
        self.view.moveAndResizeImage(scale: result.scale, xTranslation: result.xTranslation, yTranslation: result.yTranslation)
    }
}
