//
//  RegisterUserViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class RegisterUserViewController: UIViewController {
    private var presenter: RegisterUserViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: RegisterUserViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension RegisterUserViewController: RegisterUserViewPresenterOutput {
    
}

