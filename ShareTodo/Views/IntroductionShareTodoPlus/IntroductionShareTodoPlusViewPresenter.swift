//
//  IntroductionShareTodoPlusViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol IntroductionShareTodoPlusViewPresenterProtocol {
    var view: IntroductionShareTodoPlusViewPresenterOutput! { get set }
    
    func didViewDidLoad()
    func didTapApplyAMonthSubscriptionButton()
    func didTapApplyAYearSubscriptionButton()
}

protocol IntroductionShareTodoPlusViewPresenterOutput: class {
    func startActivityIndicator()
    func stopActivityIndicator()
    
    func setMonthApplySubsctiontionButtonTitle(price: String)
    func setAnnualApplySubsctiontionButtonTitle(price: String)
}

final class IntroductionShareTodoPlusViewPresenter: IntroductionShareTodoPlusViewPresenterProtocol, IntroductionShareTodoPlusModelOutput {
    weak var view: IntroductionShareTodoPlusViewPresenterOutput!
    private var model: IntroductionShareTodoPlusModelProtocol
    
    init(model: IntroductionShareTodoPlusModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchAvailableProducts()
    }
    
    func didTapApplyAMonthSubscriptionButton() {
        self.view.startActivityIndicator()
        self.model.makeMonthSubscriptionPurchase()
    }
    
    func didTapApplyAYearSubscriptionButton() {
        self.view.startActivityIndicator()
        self.model.makeAnnualSubscriptioinPurhase()
    }
    
    func successFetchMonthSubscriptionPrise(price: String) {
        self.view.setMonthApplySubsctiontionButtonTitle(price: price)
    }
    
    func successFetchAnnualSubscriptionPrise(price: String) {
        self.view.setAnnualApplySubsctiontionButtonTitle(price: price)
    }
    
    func successPurchaseMonthSubscription() {
        self.view.stopActivityIndicator()
    }
    
    func successPurchaseAnnualSubscription() {
        self.view.stopActivityIndicator()
    }
    
    
    func successRestoreMonthSubscription() {
        self.view.stopActivityIndicator()
    }
    
    func successRestoreAnnualSubscription() {
        self.view.stopActivityIndicator()
    }
}
