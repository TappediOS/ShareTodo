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
    func setHiNameLabel(user: User)
    
    func popViewController()
    
    func showErrorAleartView(error: Error)
    func showErrorAleartView()
    
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
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
        self.model.fetchUserName()
    }
    
    func successFetchSubscriptionExpiresDate(expiresDate: String) {
        self.view.setNextBilingDateLabel(expiresDate: expiresDate)
    }
    
    func successFetchUser(user: User) {
        self.view.setHiNameLabel(user: user)
    }
    
    func userEndSubscribed() {
        self.view.popViewController()
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
        self.view.noticeFeedbackOccurredError()
    }
    
    func productError() {
        self.view.showErrorAleartView()
        self.view.noticeFeedbackOccurredError()
    }
}
