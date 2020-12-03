//
//  SubscriptionStatusViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class SubscriptionStatusViewController: UIViewController {
    private var presenter: SubscriptionStatusViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: SubscriptionStatusViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension SubscriptionStatusViewController: SubscriptionStatusViewPresenterOutput {
    
}
