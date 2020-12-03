//
//  SubscriptionStatusViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import Purchases

protocol SubscriptionStatusModelProtocol {
    var presenter: SubscriptionStatusModelOutput! { get set }
    
    func checkSubscrptionExpires()
}

protocol SubscriptionStatusModelOutput: class {
    func successFetchSubscriptionExpiresDate(expiresDate: String)
    func userEndSubscribed()
    
    func error(error: Error)
    func productError()
}

final class SubscriptionStatusModel: SubscriptionStatusModelProtocol {
    weak var presenter: SubscriptionStatusModelOutput!
    
    init() {
        self.setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(endSubscribed), name: .endSubscribedNotification, object: nil)
    }
    
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
        
    }
    
    func checkSubscrptionExpires() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                self.presenter.productError()
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                self.presenter.productError()
                return
            }

            guard let expiresDate = entitlement.expirationDate else {
                self.presenter.productError()
                return
            }
            
            self.presenter.successFetchSubscriptionExpiresDate(expiresDate: self.convertDateToString(date: expiresDate))
        }
    }
    
    @objc func endSubscribed() {
        self.presenter.userEndSubscribed()
    }
}
