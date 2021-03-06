//
//  SubscriptionStatusViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import SCLAlertView

final class SubscriptionStatusViewController: UIViewController {
    private var presenter: SubscriptionStatusViewPresenterProtocol!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hiNameLabel: UILabel!
    @IBOutlet weak var thanksSubscriptionLabel: UILabel!
    @IBOutlet weak var premiumFeatureLabel: UILabel!
    @IBOutlet weak var nextBilingDateLabel: UILabel!
    @IBOutlet weak var earthImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupScrollView()
        
        self.setupEarthImageView()
        self.setupLabelLocalize()
        self.setupLabelInfomation(titleLabel)
        self.setupLabelInfomation(hiNameLabel)
        self.setupLabelInfomation(thanksSubscriptionLabel)
        self.setupLabelInfomation(premiumFeatureLabel)
        self.setupLabelInfomation(nextBilingDateLabel)
        
        self.presenter.didViewDidLoad()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.status()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func setupScrollView() {
        self.scrollView.alwaysBounceVertical = true
    }
    
    private func setupEarthImageView() {
        guard let earthImage = UIImage.getRandomEarthImage() else { return }
        self.earthImageView.image = earthImage
    }
    
    private func setupLabelLocalize() {
        self.titleLabel.text = R.string.localizable.shareTodoPlus()
        self.thanksSubscriptionLabel.text = R.string.localizable.thanksSubscriptin()
        self.premiumFeatureLabel.text = R.string.localizable.premiumFeatures()
        //NOTE:- nextBilingDateLabelのローカライズはmodelでサブスクの有効期限を取得してからセットする。
        self.nextBilingDateLabel.text = String()
        self.hiNameLabel.text = String()
    }
    
    private func setupLabelInfomation(_ label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
    }
    
    func inject(with presenter: SubscriptionStatusViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension SubscriptionStatusViewController: SubscriptionStatusViewPresenterOutput {
    func setNextBilingDateLabel(expiresDate: String) {
        self.nextBilingDateLabel.text = R.string.localizable.nextBillingDateColon(expiresDate)
    }
    
    func setHiNameLabel(user: User) {
        self.hiNameLabel.text = R.string.localizable.hiName(user.name)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showErrorAleartView(error: Error) {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        let subTitle = error.localizedDescription
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
        }
    }
    
    func showErrorAleartView() {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: nil, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
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
