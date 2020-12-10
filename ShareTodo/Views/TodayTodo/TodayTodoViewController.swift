//
//  TodayTodoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SCLAlertView
import StoreKit

final class TodayTodoViewController: UIViewController {
    private var presenter: TodayTodoViewPresenterProtocol!
    @IBOutlet weak var todayTodoCollectionView: UICollectionView!
    var activityIndicator = UIActivityIndicatorView()
    
    private let todayTodoCollectionViewCellId = "TodayTodoCollectionViewCell"
    
    let maxTextfieldLength = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupNavigationBar()
        self.setupTodayTodoCollectionView()
        self.setupActivityIndicator()
        
        self.presenter.didViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.didViewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.todayTodoCollectionView.layoutIfNeeded()
    }
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.today()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTodayTodoCollectionView() {
        self.todayTodoCollectionView.backgroundColor = .secondarySystemBackground
        self.todayTodoCollectionView.alwaysBounceVertical = true
        
        self.todayTodoCollectionView.delegate = self
        self.todayTodoCollectionView.dataSource = self
        self.todayTodoCollectionView.emptyDataSetSource = self
        self.todayTodoCollectionView.emptyDataSetDelegate = self
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    func inject(with presenter: TodayTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension TodayTodoViewController: TodayTodoViewPresenterOutput {
    func reloadTodayTodoCollectionView() {
        DispatchQueue.main.async { self.todayTodoCollectionView.reloadData() }
    }
    
    func showAddMessageEditView(index: Int) {
        let alert = SCLAlertView()
        let textField: UITextField = alert.addTextField(R.string.localizable.exampleMessage())
        textField.overrideUserInterfaceStyle = .light
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification, object: textField)
        alert.addButton(R.string.localizable.send()) {
            self.presenter.didEndAddMessage(message: textField.text, index: index)
        }
        
        let title = R.string.localizable.addMessage()
        let subTitle = R.string.localizable.addMessageSub()
        let cancelStr = R.string.localizable.cancel()
        alert.showEdit(title, subTitle: subTitle, closeButtonTitle: cancelStr, colorStyle: 0x34C759)
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func showRequestAllowNotificationView() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard granted == true else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                self.presenter.didAllowNotification()
            }
        }
    }
    
    func showSKStoreReviewController() {
        DispatchQueue.main.async {
            SKStoreReviewController.requestReview()
        }
    }
    
    func showErrorAleartView(error: Error) {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        let subTitle = error.localizedDescription
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
        }
    }
    
    func impactFeedbackOccurred_light() {
        TapticFeedbacker.impact(style: .light)
    }
    
    func impactFeedbackOccurred_medium() {
        TapticFeedbacker.impact(style: .medium)
    }
    
    func impactFeedbackOccurred_heavy() {
        TapticFeedbacker.impact(style: .heavy)
    }
    
    func noticeFeedbackOccurredError() {
        TapticFeedbacker.notice(type: .error)
    }
    
    func noticeFeedbackOccurredSuccess() {
        TapticFeedbacker.notice(type: .success)
    }
}

extension TodayTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfGroups
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayTodoCollectionViewCellId, for: indexPath) as! TodayTodoCollectionViewCell
        
        let isFinished = self.presenter.isFinishedTodo(index: indexPath.item)
        let isWrittenMessage = self.presenter.isWrittenMessage(index: indexPath.item)
        let isSubscribed = self.presenter.isUserSubscribed
        cell.configure(with: self.presenter.groups[indexPath.item], isFinished: isFinished, isWrittenMessage: isWrittenMessage, isSubscribed: isSubscribed)
        
        cell.radioButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter.didTapRadioButton(index: indexPath.item)
        }
        
        cell.writeMessageButtonAction = { [weak self] in
            guard let self = self else { return }
            self.presenter.didTapWriteMessageButtonAction(index: indexPath.item)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension TodayTodoViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bottomInset: CGFloat = self.presenter.isUserSubscribed ? 16 : 75
        return UIEdgeInsets(top: 16, left: 16, bottom: bottomInset, right: 16)
    }
    
    // cell同士の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension TodayTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField, let text = textField.text else { return }
        if textField.markedTextRange == nil && text.count > maxTextfieldLength {
            textField.text = text.prefix(self.maxTextfieldLength).description
        }
    }
}

extension TodayTodoViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = R.string.localizable.noTask()
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
   
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = R.string.localizable.dznEmptyDataSetDescription_CreateGroup()
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
