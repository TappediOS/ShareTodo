//
//  ExStoreKit.swift
//  ShareTodo
//
//  Created by jun on 2020/11/14.
//  Copyright © 2020 jun. All rights reserved.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}
