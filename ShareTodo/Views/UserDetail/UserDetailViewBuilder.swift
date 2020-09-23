//
//  UserDetailViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct UserDetailViewBuilder {
    static func create() -> UIViewController {
        guard let userDetailViewController = UserDetailViewController.loadFromStoryboard() as? UserDetailViewController else {
            fatalError("fatal: Failed to initialize the UserDetailViewController")
        }
        let model = UserDetailModel()
        let presenter = UserDetailViewPresenter(model: model)
        userDetailViewController.inject(with: presenter)
        return userDetailViewController
    }
}
