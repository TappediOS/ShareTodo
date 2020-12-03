//
//  SubscriptionStatusViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SubscriptionStatusViewPresenterProtocol {
    var view: SubscriptionStatusViewPresenterOutput! { get set }
}

protocol SubscriptionStatusViewPresenterOutput: class {
    
}

final class SubscriptionStatusViewPresenter: SubscriptionStatusViewPresenterProtocol, SubscriptionStatusModelOutput {
    weak var view: SubscriptionStatusViewPresenterOutput!
    private var model: SubscriptionStatusModelProtocol
    
    init(model: SubscriptionStatusModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
