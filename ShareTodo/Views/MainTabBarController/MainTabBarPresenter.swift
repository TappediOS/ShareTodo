//
//  MainTabBarPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol MainTabBarViewPresenterProtocol {
    var view: MainTabBarViewPresenterOutput! { get set }
}

protocol MainTabBarViewPresenterOutput: class {
    
}

final class MainTabBarViewPresenter: MainTabBarViewPresenterProtocol, MainTabBarModelOutput {
    weak var view: MainTabBarViewPresenterOutput!
    private var model: MainTabBarModelProtocol
    
    init(model: MainTabBarModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
