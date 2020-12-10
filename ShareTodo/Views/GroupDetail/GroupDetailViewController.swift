//
//  GroupDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import SCLAlertView

final class GroupDetailViewController: UIViewController {
    private var presenter: GroupDetailViewPresenterProtocol!
    
    @IBOutlet weak var groupDetailCollectionView: UICollectionView!
    var activityIndicator = UIActivityIndicatorView()
    
    let sectionTitles = [R.string.localizable.todaySProgress(), R.string.localizable.progressToDate()]
    
    var visualEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupGroupDetailCollectionView()
        self.setupActivityIndicator()
        
        self.presenter.didViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.groupDetailCollectionView.layoutIfNeeded()
    }
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationBar() {
        let title = self.presenter.group.name
        self.navigationItem.title = title
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func setupUIBarButtonItem() {
        let editGroupButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup(_:)))
        
        editGroupButtonItem.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = editGroupButtonItem
    }
    
    func setupGroupDetailCollectionView() {
        self.groupDetailCollectionView.backgroundColor = .secondarySystemBackground
        self.groupDetailCollectionView.alwaysBounceVertical = true
        self.groupDetailCollectionView.delegate = self
        self.groupDetailCollectionView.dataSource = self
        self.groupDetailCollectionView.register(UINib(resource: R.nib.groupDetailCollectionViewCell), forCellWithReuseIdentifier: "GroupDetailCell")
        self.groupDetailCollectionView.register(UINib(resource: R.nib.groupDetailCollectionViewUserCell), forCellWithReuseIdentifier: "GroupDetailUserCell")
        
        self.groupDetailCollectionView.register(UINib(resource: R.nib.groupDetailCollectionReusableView),
                                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: "header")
    
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    @objc func editGroup(_ sender: UIButton) {
        self.presenter.didTapEditGroup()
    }
    
    func inject(with presenter: GroupDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupDetailViewController: GroupDetailViewPresenterOutput {
    func reloadGroupDetailCollectionView() {
        DispatchQueue.main.async {
            self.groupDetailCollectionView.reloadData()
        }
    }
    
    func setNavigationBarTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func showEditGroupVC() {
        guard let editGroupVC = EditGroupViewBuilder.create(group: self.presenter.group, groupUsers: self.presenter.groupUsers) as? EditGroupViewController else { return }
        let navigationController = UINavigationController(rootViewController: editGroupVC)
        navigationController.modalPresentationStyle = .fullScreen
        editGroupVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func segueUserDetailViewController(index: Int) {
        let userDetailVC = UserDetailViewBuilder.create(group: self.presenter.group, user: self.presenter.groupUsers[index])
        self.navigationController?.pushViewController(userDetailVC, animated: true)
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

extension GroupDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.groupUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = self.groupDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailCell", for: indexPath) as? GroupDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let user = self.presenter.groupUsers[indexPath.item]
            let isFinishedUserIDs = self.presenter.isFinishedUsersIDs
            let messageDictionary = self.presenter.messageDictionary
            cell.configure(with: user, isFinishedUsersIDs: isFinishedUserIDs, messageDictionary: messageDictionary)
            return cell
        }
        
        guard let cell = self.groupDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailUserCell", for: indexPath) as? GroupDetailCollectionViewUserCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: self.presenter.groupUsers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        self.presenter.didTapGroupDetailCollectionViewuserCell(index: indexPath.item)
    }

}

extension GroupDetailViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: "header",
                                                                               for: indexPath) as? GroupDetailCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        headerView.setLabelTitle(title: self.sectionTitles[indexPath.section])
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 35)
    }
    
    // MARK: - FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: UIScreen.main.bounds.width - 32, height: 95)
        case 1:
            let width = UIScreen.main.bounds.width / 2 - 16 - 8
            return CGSize(width: width, height: width * 0.85)
        default: return CGSize(width: UIScreen.main.bounds.width - 32, height: 95)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0: return UIEdgeInsets(top: 4, left: 16, bottom: 24, right: 16)
        case 1: return UIEdgeInsets(top: 4, left: 16, bottom: 80, right: 16)
        default: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GroupDetailViewController: EditGroupViewControllerDelegate {
    func reaveGroupFinished(_ editprofileViewController: EditGroupViewController) {
        self.dismiss(animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func editGroupViewControllerDidFinish(group: Group, groupUsers: [User]) {
        self.dismiss(animated: true, completion: nil)
        self.presenter.didFinishedEditGroup(group: group, groupUsers: groupUsers)
    }
    
    func editGroupViewControllerDidCanceled(_ editprofileViewController: EditGroupViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
