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
    @IBOutlet weak var accountLabel: UILabel! { didSet { accountLabel.text = R.string.localizable.account() }}
    @IBOutlet weak var statusLabel: UILabel! { didSet { statusLabel.text = R.string.localizable.status() }}
    @IBOutlet weak var restoreLabel: UILabel! { didSet { restoreLabel.text = R.string.localizable.restore() }}
    @IBOutlet weak var pushNotificationsLabel: UILabel! { didSet { pushNotificationsLabel.text = R.string.localizable.pushNotifications() }}
    @IBOutlet weak var askQuestionsLabel: UILabel! { didSet { askQuestionsLabel.text = R.string.localizable.askQuestions() }}
    @IBOutlet weak var feedbackLabel: UILabel! { didSet { feedbackLabel.text = R.string.localizable.feedback() }}
    @IBOutlet weak var reviewInAppStoreLabel: UILabel! { didSet { reviewInAppStoreLabel.text = R.string.localizable.reviewInAppStore() }}
    @IBOutlet weak var reviewDescriptionLabel: UILabel! { didSet { reviewDescriptionLabel.text = R.string.localizable.reviewDesctiption() }}
    @IBOutlet weak var shareShareTodoLabel: UILabel! { didSet { shareShareTodoLabel.text = R.string.localizable.shareShareTodo() }}
    @IBOutlet weak var termOfUseLabel: UILabel! { didSet { termOfUseLabel.text = R.string.localizable.termOfUse() }}
    @IBOutlet weak var privacyPolicyLabel: UILabel! { didSet { privacyPolicyLabel.text = R.string.localizable.privacyPolicy() }}
    @IBOutlet weak var versionLabel: UILabel! { didSet { versionLabel.text = R.string.localizable.version(R.string.sharedString.appVersion()) }}
    
    @IBOutlet weak var bellImageView: UIImageView! {
        didSet { if #available(iOS 14.0, *) { bellImageView.image = UIImage(systemName: "bell.badge") } }
    }
    @IBOutlet weak var lassoImageView: UIImageView! {
        didSet { if #available(iOS 14.0, *) { lassoImageView.image = UIImage(systemName: "lasso.sparkles") } }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupNavigationItem()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.me()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.leftBarButtonItem?.tintColor = .systemGray
        self.navigationItem.title = R.string.localizable.settings()
    }
    
    @objc func tapStopButton() {
        self.presenter.didTapStopButton()
    }
    
    func inject(with presenter: SettingViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.presenter.getTitleforHeaderInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingViewController: SettingViewPresenterOutput {
    func dismissSettingVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
