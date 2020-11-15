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
}

protocol MainTabBarViewPresenterOutput: class {
    func initBannerAds()
    func showBannerAds()
    func dismissBannerAds()
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
    
    
    func userSubscribed() {
        self.view.dismissBannerAds()
    }
    
    func userDontSubscribed() {
        self.view.initBannerAds()
        self.view.showBannerAds()
    }
}
