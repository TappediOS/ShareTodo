//
//  InviteUsersViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/10/22.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct InviteUsersViewBuilder {
    static func create() -> UIViewController {
        guard let InviteUsersViewController = InviteUsersViewController.loadFromStoryboard() as? InviteUsersViewController else {
            fatalError("fatal: Failed to initialize the SampleViewController")
        }
        let model = InviteUsersModel()
        let presenter = InviteUsersViewPresenter(model: model)
        InviteUsersViewController.inject(with: presenter)
        return InviteUsersViewController
    }
}
