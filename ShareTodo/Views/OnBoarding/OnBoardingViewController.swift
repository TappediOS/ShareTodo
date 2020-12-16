//
//  OnBoardingViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/15.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class OnBoardingViewController: UIViewController {
    private var presenter: OnBoardingViewPresenterProtocol!
    @IBOutlet weak var onBoardingTextLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupOnBoardingTextLabel()
        self.setupCreateAccountButton()
    }
    
    private func setupOnBoardingTextLabel() {
        self.onBoardingTextLabel.text = R.string.localizable.onBoardingText()
        self.onBoardingTextLabel.adjustsFontSizeToFitWidth = true
        self.onBoardingTextLabel.minimumScaleFactor = 0.4
    }
    
    private func setupCreateAccountButton() {
        self.createAccountButton.setTitle(R.string.localizable.createAccount(), for: .normal)
        self.createAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.createAccountButton.titleLabel?.minimumScaleFactor = 0.4
    }
    
    @IBAction func tapCreateAccountButton(_ sender: Any) {
        self.presenter.didTapCreateAccountButton()
    }
    
    func inject(with presenter: OnBoardingViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension OnBoardingViewController: OnBoardingViewPresenterOutput {
    func segueRegisterUserVC() {
        let registerUserVC = RegisterUserViewBuilder.create()
        registerUserVC.modalPresentationStyle = .fullScreen
        registerUserVC.modalTransitionStyle = .crossDissolve
        
        self.present(registerUserVC, animated: true, completion: nil)
    }
    
    func impactFeedbackOccurred() {
        TapticFeedbacker.impact(style: .heavy)
    }
    
    func noticeFeedbackOccurredError() {
        TapticFeedbacker.notice(type: .error)
    }
    
    func noticeFeedbackOccurredSuccess() {
        TapticFeedbacker.notice(type: .success)
    }
}
