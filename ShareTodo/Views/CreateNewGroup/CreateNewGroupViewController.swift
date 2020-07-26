//
//  CreateNewGroupViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class CreateNewGroupViewController: UIViewController {
    private var presenter: CreateNewGroupViewPresenterProtocol!
    @IBOutlet weak var searchUserTableview: UITableView!
    @IBOutlet weak var selectedUserCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: CreateNewGroupViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension CreateNewGroupViewController: CreateNewGroupViewPresenterOutput {
    
}

