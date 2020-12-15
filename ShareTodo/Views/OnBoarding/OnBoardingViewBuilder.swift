//
//  OnBoardingViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/12/15.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct OnBoardingViewBuilder {
    static func create() -> UIViewController {
        guard let onBoardingViewController = OnBoardingViewController.loadFromStoryboard() as? OnBoardingViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = OnBoardingModel()
        let presenter = OnBoardingViewPresenter(model: model)
        onBoardingViewController.inject(with: presenter)
        return onBoardingViewController
    }
}
