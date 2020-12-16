//
//  Routes.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Firebase

struct Routes {
    static func decideRootViewController() -> UIViewController {
        if Auth.auth().currentUser == nil {
            return OnBoardingViewBuilder.create()
        }
        
        return MainTabBarViewBuilder.create()
    }
}
