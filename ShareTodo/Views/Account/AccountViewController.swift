//
//  AccountViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class AccountViewController: UITableViewController {
    private var presenter: AccountViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: AccountViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension AccountViewController: AccountViewPresenterOutput {
    
}
