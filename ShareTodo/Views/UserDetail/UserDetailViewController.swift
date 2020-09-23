//
//  UserDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class UserDetailViewController: UIViewController {
    private var presenter: UserDetailViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupTaskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: UserDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension UserDetailViewController: UserDetailViewPresenterOutput {
    
}
