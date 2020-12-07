//
//  SettingViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import SafariServices
import LinkPresentation
import SCLAlertView

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
    
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.text = R.string.localizable.version(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
        }
    }
    
    @IBOutlet weak var bellImageView: UIImageView! {
        didSet { if #available(iOS 14.0, *) { bellImageView.image = UIImage(systemName: "bell.badge") } }
    }
    @IBOutlet weak var lassoImageView: UIImageView! {
        didSet { if #available(iOS 14.0, *) { lassoImageView.image = UIImage(systemName: "lasso.sparkles") } }
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupNavigationItem()
        self.setupActivityIndicator()
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
    
    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
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
        
        self.presenter.didTapTableViewCell(indexPath: indexPath)
    }
}

extension SettingViewController: SettingViewPresenterOutput {
    func dismissSettingVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func openAccountVC() {
        let accountVC = AccountViewBuilder.create()
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    func openSubscriptionStatusVC() {
        guard let subscriptionStatusVC = SubscriptionStatusViewBuilder.create() as? SubscriptionStatusViewController else { return }
        self.navigationController?.pushViewController(subscriptionStatusVC, animated: true)
    }
    
    func openIntroductionShareTodoPlusVC() {
        let introductionShareTodoPlusVC = IntroductionShareTodoPlusViewBuilder.create()
        self.navigationController?.pushViewController(introductionShareTodoPlusVC, animated: true)
    }
    
    // 設定画面を開く
    func openPushNotificationVC(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openAskQuestionVC(url: URL) {
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.modalPresentationStyle = .pageSheet
        self.present(sfSafariVC, animated: true, completion: nil)
    }
    
    func openFeedbackVC(url: URL) {
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.modalPresentationStyle = .pageSheet
        self.present(sfSafariVC, animated: true, completion: nil)
    }
    
    func endIgnoringInteractionEvents() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func beginIgnoringInteractionEvents() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func openReviewInAppStore(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showShareActivityVC(shareText: String?, shareURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func openTermOfUseVC(url: URL) {
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.modalPresentationStyle = .pageSheet
        self.present(sfSafariVC, animated: true, completion: nil)
    }
    
    func openPrivacyPolicyVC(url: URL) {
        let sfSafariVC = SFSafariViewController(url: url)
        sfSafariVC.modalPresentationStyle = .pageSheet
        self.present(sfSafariVC, animated: true, completion: nil)
    }
    
    func showRestoreAleartView() {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.done()
        let subTitle = R.string.localizable.successRestore()
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0x34C759, colorTextButton: 0xFFFFFF)
        }
    }
    
    func showErrorAleartView(error: Error) {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        let subTitle = error.localizedDescription
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
        }
    }
    
    func impactFeedbackOccurred() {
        TapticFeedbacker.impact(style: .light)
    }
    
    func noticeFeedbackOccurredError() {
        TapticFeedbacker.notice(type: .error)
    }
    
    func noticeFeedbackOccurredSuccess() {
        TapticFeedbacker.notice(type: .success)
    }
}
