//
//  AccountViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import SCLAlertView

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
        
        self.setupLabelLocalize()
        self.setupLabelInfomation(userNameLabel)
        self.setupLabelInfomation(userIdLabel)
        self.setupLabelInfomation(idLabel)
        
        self.presenter.didViewDidLoad()
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
    
    private func setupLabelLocalize() {
        self.userNameLabel.text = String()
        self.userIdLabel.text = String()
        self.isRegisterFcmTokenLabel.text = String()
    }
    
    private func setupLabelInfomation(_ label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
    }
    
    func inject(with presenter: AccountViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.presenter.didTapTableViewCell(indexPath: indexPath)
    }
}

extension AccountViewController: AccountViewPresenterOutput {
    func setUserName(name: String) {
        self.userNameLabel.text = name
    }
    
    func setUserID(uid: String) {
        self.userIdLabel.text = uid
    }
    
    func setNotificationLabel(status: String) {
        self.notificationsLabel.text = status
    }
    
    func showErrorAleartView(error: Error) {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        let subTitle = error.localizedDescription
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
        }
    }
}
