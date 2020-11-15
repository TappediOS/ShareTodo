//
//  MainTabBarModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Purchases

protocol MainTabBarModelProtocol {
    var presenter: MainTabBarModelOutput! { get set }
    
    func checkingIfAUserSubscribed()
}

protocol MainTabBarModelOutput: class {
    func userSubscribed()
    func userDontSubscribed()
}

final class MainTabBarModel: MainTabBarModelProtocol {
    weak var presenter: MainTabBarModelOutput!
    
    func checkingIfAUserSubscribed() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                return
            }
            
            guard entitlement.isActive == true else {
                self.presenter.userDontSubscribed()
                return
            }
            
            self.presenter.userSubscribed()
        }
    }
}
