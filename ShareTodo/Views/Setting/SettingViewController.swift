//
//  SettingViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class SettingViewController: UITableViewController {
    private var presenter: SettingViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: SettingViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension SettingViewController: SettingViewPresenterOutput {
    
}
