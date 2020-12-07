//
//  ProfileViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewPresenterOutput! { get set }
    var isUserSubscribed: Bool { get }
    
    func didTapEditProfileButton()
    func didTapSettingButton()
    func didTapPlanStateButton()
    func didViewDidLoad()
    func didVeiwWillAppear()
}

protocol ProfileViewPresenterOutput: class {
    func presentEditProfileVC()
    func presentSettingVC()
    func setUserName(userName: String)
    func setProfileImage(URL: URL)
    
    func setPlanLabelAsSubscribed()
    func setPlanStatusLabelAsSubscribed()
    func setPlanStatusButtonAsSubscribed()
    func setPlanLabelAsNonSubscribed()
    func setPlanStatusLabelAsNonSubscribed()
    func setPlanStatusButtonAsNonSubscribed()
    
    func segueIntroductionShareTodoVC()
    func segueSubscriptionStatusVC()
    
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol, ProfileModelOutput {
    weak var view: ProfileViewPresenterOutput!
    private var model: ProfileModelProtocol
    
    var isUserSubscribed: Bool { return self.model.isUserSubscribed }
    
    init(model: ProfileModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapEditProfileButton() {
        self.view.presentEditProfileVC()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapSettingButton() {
        self.view.presentSettingVC()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapPlanStateButton() {
        if self.isUserSubscribed == false {
            self.view.segueIntroductionShareTodoVC()
        } else {
            self.view.segueSubscriptionStatusVC()
        }
        self.view.impactFeedbackOccurred()
    }
    
    func didViewDidLoad() {
        self.model.fetchUser()
    }
    
    func didVeiwWillAppear() {
        self.model.checkingIfAUserSubscribed()
    }
    
    
    func successFetchUser(user: User) {
        self.view.setUserName(userName: user.name)
        guard let url = URL(string: user.profileImageURL ?? "") else { return }
        self.view.setProfileImage(URL: url)
    }
    
    func userSubscribed() {
        self.view.setPlanLabelAsSubscribed()
        self.view.setPlanStatusLabelAsSubscribed()
        self.view.setPlanStatusButtonAsSubscribed()
    }
    
    func userDontSubscribed() {
        self.view.setPlanLabelAsNonSubscribed()
        self.view.setPlanStatusLabelAsNonSubscribed()
        self.view.setPlanStatusButtonAsNonSubscribed()
    }
    
    func userStartSubscribed() {
        self.model.checkingIfAUserSubscribed()
        self.view.noticeFeedbackOccurredSuccess()
    }
    
    func userEndSubscribed() {
        self.model.checkingIfAUserSubscribed()
    }
}
