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
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupActivityIndicator()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.account()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }

    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    func inject(with presenter: AccountViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension AccountViewController: AccountViewPresenterOutput {
    
}
