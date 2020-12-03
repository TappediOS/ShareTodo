//
//  SubscriptionStatusViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SubscriptionStatusModelProtocol {
    var presenter: SubscriptionStatusModelOutput! { get set }
}

protocol SubscriptionStatusModelOutput: class {
    
}

final class SubscriptionStatusModel: SubscriptionStatusModelProtocol {
    weak var presenter: SubscriptionStatusModelOutput!
}
