//
//  SubscriptionStatusViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct SubscriptionStatusViewBuilder {
    static func create() -> UIViewController {
        guard let subscriptionStatusViewController = SubscriptionStatusViewController.loadFromStoryboard() as? SubscriptionStatusViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = SubscriptionStatusModel()
        let presenter = SubscriptionStatusViewPresenter(model: model)
        subscriptionStatusViewController.inject(with: presenter)
        return subscriptionStatusViewController
    }
}
