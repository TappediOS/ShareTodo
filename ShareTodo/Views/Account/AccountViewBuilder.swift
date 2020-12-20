//
//  AccountViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct AccountViewBuilder {
    static func create() -> UIViewController {
        guard let accountViewController = R.storyboard.account().instantiateInitialViewController() as? AccountViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = AccountModel()
        let presenter = AccountViewPresenter(model: model)
        accountViewController.inject(with: presenter)
        return accountViewController
    }
}
