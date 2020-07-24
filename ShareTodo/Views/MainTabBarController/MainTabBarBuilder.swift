//
//  MainTabBarBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct MainTabBarViewBuilder {
    static func create() -> UIViewController {
        guard let mainTabBarViewController = MainTabBarViewController.loadFromStoryboard() as? MainTabBarViewController else {
            fatalError("fatal: Failed to initialize the MainTabBarViewController")
        }
        let model = MainTabBarModel()
        let presenter = MainTabBarViewPresenter(model: model)
        mainTabBarViewController.inject(with: presenter)
        return mainTabBarViewController
    }
}
