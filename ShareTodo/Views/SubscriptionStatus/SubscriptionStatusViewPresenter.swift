//
//  SubscriptionStatusViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SubscriptionStatusViewPresenterProtocol {
    var view: SubscriptionStatusViewPresenterOutput! { get set }
    
    func didViewDidLoad()
}

protocol SubscriptionStatusViewPresenterOutput: class {
    func setNextBilingDateLabel(expiresDate: String)
    
    func popViewController()
    
    func showErrorAleartView(error: Error)
    func showErrorAleartView()
}

final class SubscriptionStatusViewPresenter: SubscriptionStatusViewPresenterProtocol, SubscriptionStatusModelOutput {
    weak var view: SubscriptionStatusViewPresenterOutput!
    private var model: SubscriptionStatusModelProtocol
    
    init(model: SubscriptionStatusModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.checkSubscrptionExpires()
    }
    
    func successFetchSubscriptionExpiresDate(expiresDate: String) {
        self.view.setNextBilingDateLabel(expiresDate: expiresDate)
    }
    
    func userEndSubscribed() {
        self.view.popViewController()
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
    }
    
    func productError() {
        self.view.showErrorAleartView()
    }
}
