//
//  Routes.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

struct Routes {
    static func decideRootViewController() -> UIViewController {
        return MainTabBarViewBuilder.create()
    }
}
