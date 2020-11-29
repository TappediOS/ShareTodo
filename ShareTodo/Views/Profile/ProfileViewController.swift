//
//  ProfileViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke

final class ProfileViewController: UIViewController {
    private var presenter: ProfileViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var planStatusLabel: UILabel!
    @IBOutlet weak var planStateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScrollView()
        self.setupProfileImageView()
        self.setupNameLabel()
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupPlanLabel()
        self.setupPlanStatusLabel()
        self.setupPlanStateButton()
        
        
        self.presenter.didViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.didVeiwWillAppear()
    }
    
    func setupScrollView() {
        self.scrollView.alwaysBounceVertical = true
    }
    
    func setupProfileImageView() {
        self.profileImageView.image = R.image.defaultProfileImage()
        self.profileImageView.layer.borderWidth = 0.25
        self.profileImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.layer.masksToBounds = true
    }
    
    func setupNameLabel() {
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.minimumScaleFactor = 0.4
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.me()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let editProfileButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile(_:)))
        let settingButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(setting(_:)))
        editProfileButtonItem.tintColor = .systemGreen
        settingButtonItem.tintColor = .systemGreen
        
        self.navigationItem.leftBarButtonItem = settingButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = editProfileButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupPlanLabel() {
        self.planLabel.text = ""
        self.planLabel.adjustsFontSizeToFitWidth = true
        self.planLabel.minimumScaleFactor = 0.4
    }
    
    private func setupPlanStatusLabel() {
        self.planStatusLabel.text = ""
        self.planStatusLabel.adjustsFontSizeToFitWidth = true
        self.planStatusLabel.minimumScaleFactor = 0.4
    }
    
    private func setupPlanStateButton() {
        self.planStateButton.alpha = 0
    }

    @objc func editProfile(_ sender: UIButton) {
        self.presenter.didTapEditProfileButton()
    }
    
    @objc func setting(_ sender: UIButton) {
        self.presenter.didTapSettingButton()
    }
    
    @IBAction func tapPlabStateButton(_ sender: Any) {
        self.presenter.didTapPlanStateButton()
    }
    
    
    func inject(with presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension ProfileViewController: ProfileViewPresenterOutput {
    func setPlanLabelAsSubscribed() {
        self.planLabel.text = R.string.localizable.plan()
    }
    
    func setPlanStatusLabelAsSubscribed() {
        self.planStatusLabel.text = R.string.localizable.premiunPlan()
    }
    
    func setPlanStatusButtonAsSubscribed() {
        self.planStateButton.alpha = 0.85
    }
    
    func setPlanLabelAsNonSubscribed() {
        self.planLabel.text = R.string.localizable.plan()
    }
    
    func setPlanStatusLabelAsNonSubscribed() {
        self.planStatusLabel.text = R.string.localizable.freePlan()
    }
    
    func setPlanStatusButtonAsNonSubscribed() {
        self.planStateButton.alpha = 0.4
    }
    
    func presentEditProfileVC() {
        guard let editProfileVC = EditProfileViewBuilder.create() as? EditProfileViewController else { return }
        editProfileVC.profileImage = self.profileImageView.image ?? UIImage()
        editProfileVC.userName = self.nameLabel.text
        
        let navigationController = UINavigationController(rootViewController: editProfileVC)
        navigationController.modalPresentationStyle = .pageSheet
        
        navigationController.presentationController?.delegate = editProfileVC
        editProfileVC.delegate = self
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func presentSettingVC() {
        guard let settingVC = SettingViewBuilder.create() as? SettingViewController else { return }
        let navigationController = UINavigationController(rootViewController: settingVC)
        navigationController.modalPresentationStyle = .pageSheet
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func setUserName(userName: String) {
        self.nameLabel.text = userName
    }
    
    func setProfileImage(URL: URL) {
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.defaultProfileImage())
            loadImage(with: URL, options: options, into: self.profileImageView, progress: nil, completion: { _ in
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            })
        }
    }
    
    func segueIntroductionShareTodoVC() {
        let introductionShareTodoPlusVC = IntroductionShareTodoPlusViewBuilder.create()
        self.navigationController?.pushViewController(introductionShareTodoPlusVC, animated: true)
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func editViewControllerDidCancel(_ editProfileViewController: EditProfileViewController) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    func editViewControllerDidFinish(_ editProfileViewController: EditProfileViewController) {
        print("didFinish")
        self.dismiss(animated: true, completion: nil)
    }
}
