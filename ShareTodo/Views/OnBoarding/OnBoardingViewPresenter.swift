//
//  OnBoardingViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/12/15.
//  Copyright © 2020 jun. All rights reserved.
//

protocol OnBoardingViewPresenterProtocol {
    var view: OnBoardingViewPresenterOutput! { get set }

    func didViewDidAppear()
    func didTapCreateAccountButton()
}

protocol OnBoardingViewPresenterOutput: class {
    func segueRegisterUserVC()
    
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class OnBoardingViewPresenter: OnBoardingViewPresenterProtocol, OnBoardingModelOutput {
    weak var view: OnBoardingViewPresenterOutput!
    private var model: OnBoardingModelProtocol
    
    init(model: OnBoardingModelProtocol) {
        self.model = model
        self.model.presenter = self
    }

    func didViewDidAppear() {
        self.model.requestAdsTrackingIfNeeded()
    }
    
    func didTapCreateAccountButton() {
        self.view.segueRegisterUserVC()
        self.view.impactFeedbackOccurred()
    }
}
