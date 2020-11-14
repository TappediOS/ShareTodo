//
//  IntroductionShareTodoPlusViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Purchases

final class IntroductionShareTodoPlusViewController: UIViewController {
    private var presenter: IntroductionShareTodoPlusViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var premiumFeatureLabel: UILabel!
    @IBOutlet weak var noAdsImageLabel: UILabel!
    @IBOutlet weak var checkPastImageLabel: UILabel!
    @IBOutlet weak var addMessageImageLabel: UILabel!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var noAdsDescriptionLabel: UILabel!
    @IBOutlet weak var checkPastLabel: UILabel!
    @IBOutlet weak var checkPastDescriptionLabel: UILabel!
    @IBOutlet weak var addMessageLabel: UILabel!
    @IBOutlet weak var addMessageDescrioptionLabel: UILabel!
    @IBOutlet weak var applySubscriptionButton: UIButton!
    @IBOutlet weak var subscriptionNotesLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupView()
        self.setupScrollView()
        self.setupNavigationBar()
        
        self.setupApplySubscriptionButton()
        
        self.setupLabelText()
        self.setupLabelInfomation(premiumFeatureLabel)
        self.setupLabelInfomation(noAdsImageLabel)
        self.setupLabelInfomation(checkPastImageLabel)
        self.setupLabelInfomation(addMessageImageLabel)
        self.setupLabelInfomation(noAdsLabel)
        self.setupLabelInfomation(noAdsDescriptionLabel)
        self.setupLabelInfomation(checkPastLabel)
        self.setupLabelInfomation(checkPastDescriptionLabel)
        self.setupLabelInfomation(addMessageLabel)
        self.setupLabelInfomation(addMessageDescrioptionLabel)
        self.setupLabelInfomation(subscriptionNotesLabel)
        
        self.setupActivityIndicator()
        
    }
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupScrollView() {
        self.scrollView.alwaysBounceVertical = true
    }
    
    func setupNavigationBar() {
        //TODO:- ローカライズ
        self.navigationItem.title = "ShareTodo Plus"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func setupApplySubscriptionButton() {
        //TODO:- ローカライズすること
        self.applySubscriptionButton.setTitle("¥300/月で申し込む", for: .normal)
    }
    
    func setupLabelInfomation(_ label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
    }
    
    func setupLabelText() {
        premiumFeatureLabel.text         = R.string.localizable.premiumFeatures()
        noAdsImageLabel.text             = R.string.localizable.noAds()
        checkPastImageLabel.text         = R.string.localizable.checkPastTasks()
        addMessageImageLabel.text        = R.string.localizable.addMessageToTask()
        noAdsLabel.text                  = R.string.localizable.noAdsExMark()
        noAdsDescriptionLabel.text       = R.string.localizable.noAdsDescription()
        checkPastLabel.text              = R.string.localizable.checkPastTasks()
        checkPastDescriptionLabel.text   = R.string.localizable.checkPastTasksDescription()
        addMessageLabel.text             = R.string.localizable.addMessageToTaskExMark()
        addMessageDescrioptionLabel.text = R.string.localizable.addMessageToTaskDescription()
        subscriptionNotesLabel.text      = R.string.localizable.explanationOfSubscriptionNotes()
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    
    
    @IBAction func tapApplyAMonthSubscriptionButton(_ sender: Any) {
        self.presenter.didTapApplyAMonthSubscriptionButton()
    }
    
    func inject(with presenter: IntroductionShareTodoPlusViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension IntroductionShareTodoPlusViewController: IntroductionShareTodoPlusViewPresenterOutput {
    func startActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
}
