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
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.today()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTodayTodoCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 95)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 40, right: 16)
        
        self.todayTodoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.todayTodoCollectionView.backgroundColor = .secondarySystemBackground
        self.todayTodoCollectionView.alwaysBounceVertical = true
        
        self.todayTodoCollectionView.delegate = self
        self.todayTodoCollectionView.dataSource = self
        self.todayTodoCollectionView.emptyDataSetSource = self
        self.todayTodoCollectionView.emptyDataSetDelegate = self
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.center = self.view.center
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
}

extension TodayTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfGroups
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayTodoCollectionViewCellId, for: indexPath) as! TodayTodoCollectionViewCell
        
        let isFinished = self.presenter.isFinishedTodo(index: indexPath.item)
        let isWrittenMessage = self.presenter.isWrittenMessage(index: indexPath.item)
        cell.configure(with: self.presenter.groups[indexPath.item], isFinished: isFinished, isWrittenMessage: isWrittenMessage)
        
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
