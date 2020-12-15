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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: OnBoardingViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension OnBoardingViewController: OnBoardingViewPresenterOutput {
    
}
