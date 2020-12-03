//
//  SubscriptionStatusViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/12/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class SubscriptionStatusViewController: UIViewController {
    private var presenter: SubscriptionStatusViewPresenterProtocol!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hiNameLabel: UILabel!
    @IBOutlet weak var thanksSubscriptionLabel: UILabel!
    
    @IBOutlet weak var premiumFeatureLabel: UILabel!
    @IBOutlet weak var nextBilingDateLabel: UILabel!
    
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLabelLocalize()
        self.setupLabelInfomation(titleLabel)
        self.setupLabelInfomation(hiNameLabel)
        self.setupLabelInfomation(thanksSubscriptionLabel)
        self.setupLabelInfomation(premiumFeatureLabel)
        self.setupLabelInfomation(nextBilingDateLabel)
    }
    
    private func setupLabelLocalize() {
        self.titleLabel.text = R.string.localizable.shareTodoPlus()
        self.hiNameLabel.text = R.string.localizable.hiName(self.userName ?? "")
        self.premiumFeatureLabel.text = R.string.localizable.premiumFeatures()
        //NOTE:- nextBilingDateLabelのローカライズはmodelでサブスクの有効期限を取得してからセットする。
        self.nextBilingDateLabel.text = String()
    }
    
    private func setupLabelInfomation(_ label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
    }
    
    public func setUserName(userName: String) {
        self.userName = userName
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
}
