//
//  MainTabBarPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol MainTabBarViewPresenterProtocol {
    var view: MainTabBarViewPresenterOutput! { get set }
    
    func didViewDidAppear()
    func didTapTabBarItem()
}

protocol MainTabBarViewPresenterOutput: class {
    func initBannerAds()
    func showBannerAds()
    func dismissBannerAds()
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class MainTabBarViewPresenter: MainTabBarViewPresenterProtocol, MainTabBarModelOutput {
    weak var view: MainTabBarViewPresenterOutput!
    private var model: MainTabBarModelProtocol
    
    init(model: MainTabBarModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidAppear() {
        self.model.checkingIfAUserSubscribed()
    }
    
    func didTapTabBarItem() {
        self.view.impactFeedbackOccurred()
    }
    
    func userSubscribed() {
        self.view.dismissBannerAds()
    }
    
    func userDontSubscribed() {
        self.view.initBannerAds()
        self.view.showBannerAds()
    }
    
    func userStartSubscribed() {
        self.view.dismissBannerAds()
    }
    
    func userEndSubscribed() {
        self.view.initBannerAds()
        self.view.showBannerAds()
    }
}
