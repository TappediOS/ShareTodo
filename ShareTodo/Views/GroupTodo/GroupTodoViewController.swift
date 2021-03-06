//
//  GroupTodoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import SCLAlertView
import DZNEmptyDataSet
import GoogleMobileAds

final class GroupTodoViewController: UIViewController {
    private var presenter: GroupTodoViewPresenterProtocol!
    @IBOutlet weak var groupTableView: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    
    private let groupTodoCellID = "GroupTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupGroupTableView()
        self.setupActivityIndicator()
        
        self.presenter.didViewDidLoad()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.group()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let makeGroupButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                  style: .plain, target: self, action: #selector(makeGroup(_:)))
       
        makeGroupButtonItem.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = makeGroupButtonItem
    }
    
    func setupGroupTableView() {
        self.groupTableView.rowHeight = 96
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.emptyDataSetSource = self
        self.groupTableView.emptyDataSetDelegate = self
        self.groupTableView.tableFooterView = UIView()
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    /// plusボタン押されたときの処理gropuを作成する
    /// - Parameter sender: button
    @objc func makeGroup(_ sender: UIButton) {
        self.presenter.didTapMakeGroupButton()
    }
    
    func inject(with presenter: GroupTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupTodoViewController: GroupTodoViewPresenterOutput {
    func reloadGroupTableView() {
        DispatchQueue.main.async { self.groupTableView.reloadData() }
    }
    
    func setTableViewInsetBottoms(isSubscribed: Bool) {
        print(GADAdSize().size.width)
        self.groupTableView.contentInset.bottom = isSubscribed ? 0 : 110
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func showCreateNewGroupVC() {
        guard let createNewGroupVC = CreateNewGroupViewBuilder.create(searchUsersType: .createGroup) as? CreateNewGroupViewController else { return }
        let navigationController = UINavigationController(rootViewController: createNewGroupVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func segueGroupDetailViewController(index: Int) {
        let groupDetailVC = GroupDetailViewBuilder.create(group: self.presenter.group[index], groupUsers: self.presenter.groupUsers[index])
        self.navigationController?.pushViewController(groupDetailVC, animated: true)
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

extension GroupTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfGroup
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.groupTableView.dequeueReusableCell(withIdentifier: self.groupTodoCellID, for: indexPath)
                         as? GroupTableViewCell else { return UITableViewCell() }
        
        cell.configure(group: self.presenter.group[indexPath.item], user: self.presenter.groupUsers[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupTableView.deselectRow(at: indexPath, animated: true)
        
        self.presenter.didTapGroupTableViewCell(index: indexPath.item)
    }
}

extension GroupTodoViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
