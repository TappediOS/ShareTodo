//
//  IntroductionShareTodoPlusViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct IntroductionShareTodoPlusViewBuilder {
    static func create() -> UIViewController {
        guard let introductionShareTodoPlusViewController = IntroductionShareTodoPlusViewController.loadFromStoryboard() as? IntroductionShareTodoPlusViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = IntroductionShareTodoPlusModel()
        let presenter = IntroductionShareTodoPlusViewPresenter(model: model)
        introductionShareTodoPlusViewController.inject(with: presenter)
        return introductionShareTodoPlusViewController
    }
}
