//
//  GroupDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    private var presenter: GroupDetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: GroupDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupDetailViewController: GroupDetailViewPresenterOutput {
    
}
