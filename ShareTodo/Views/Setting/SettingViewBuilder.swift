//
//  SettingViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct SettingViewBuilder {
    static func create() -> UIViewController {
        guard let settingViewController = R.storyboard.setting().instantiateInitialViewController() as? SettingViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = SettingModel()
        let presenter = SettingViewPresenter(model: model)
        settingViewController.inject(with: presenter)
        return settingViewController
    }
}
