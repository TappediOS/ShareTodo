//
//  CreateNewGroupViewBuilder.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

enum SearchUsersType {
    case createGroup
    case inviteUsers
}

struct CreateNewGroupViewBuilder {
    static func create(searchUsersType: SearchUsersType) -> UIViewController {
        guard let createNewGroupViewController = CreateNewGroupViewController.loadFromStoryboard() as? CreateNewGroupViewController else {
            fatalError("fatal: Failed to initialize the CreateNewGroupViewController")
        }
        let model = CreateNewGroupModel(searchUsersType: searchUsersType)
        let presenter = CreateNewGroupViewPresenter(model: model)
        createNewGroupViewController.inject(with: presenter)
        return createNewGroupViewController
    }
}
