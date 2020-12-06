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
    @IBOutlet weak var nameLabel: UILabel! { didSet { nameLabel.text = R.string.localizable.name() }}
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel! { didSet { idLabel.text = R.string.localizable.userId() }}
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel! { didSet { notificationsLabel.text = R.string.localizable.notifications() }}
    @IBOutlet weak var isRegisterFcmTokenLabel: UILabel!
    @IBOutlet weak var deleteAccountLebel: UILabel! { didSet { deleteAccountLebel.text = R.string.localizable.deleteAccount() }}
    
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
