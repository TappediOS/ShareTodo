//
//  CreateNewGroupInfoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class CreateNewGroupInfoViewController: UIViewController {
    private var presenter: CreateNewGroupInfoViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: CreateNewGroupInfoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension CreateNewGroupInfoViewController: CreateNewGroupInfoViewPresenterOutput {
    
}
