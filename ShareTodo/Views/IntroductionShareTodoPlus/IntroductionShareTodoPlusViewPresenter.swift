//
//  IntroductionShareTodoPlusViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol IntroductionShareTodoPlusViewPresenterProtocol {
    var view: IntroductionShareTodoPlusViewPresenterOutput! { get set }

    func didTapApplyAMonthSubscriptionButton()
    func didTapApplyAYearSubscriptionButton()
}

protocol IntroductionShareTodoPlusViewPresenterOutput: class {
    func startActivityIndicator()
    func stopActivityIndicator()
}

final class IntroductionShareTodoPlusViewPresenter: IntroductionShareTodoPlusViewPresenterProtocol, IntroductionShareTodoPlusModelOutput {
    weak var view: IntroductionShareTodoPlusViewPresenterOutput!
    private var model: IntroductionShareTodoPlusModelProtocol
    
    init(model: IntroductionShareTodoPlusModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapApplyAMonthSubscriptionButton() {
        
    }
    
    func didTapApplyAYearSubscriptionButton() {
        
    }
}
