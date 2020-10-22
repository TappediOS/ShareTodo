//
//  InviteUsersViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/10/22.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class InviteUsersViewController: UIViewController {
    private var presenter: InviteUsersViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: InviteUsersViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension InviteUsersViewController: InviteUsersViewPresenterOutput {
    
}
