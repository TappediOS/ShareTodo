//
//  EditGroupViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class EditGroupViewController: UIViewController {
    private var presenter: EditGroupViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: EditGroupViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension EditGroupViewController: EditGroupViewPresenterOutput {
    
}
