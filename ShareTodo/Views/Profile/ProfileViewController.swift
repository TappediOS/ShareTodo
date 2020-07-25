//
//  ProfileViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var presenter: ProfileViewPresenterProtocol!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupProfileImageView()
        self.setupNameLabel()
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
    }
    
    func setupProfileImageView() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.layer.masksToBounds = true
    }
    
    func setupNameLabel() {
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.minimumScaleFactor = 0.4
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Me"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let editProfileButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile(_:)))
        editProfileButtonItem.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = editProfileButtonItem
    }

    @objc func editProfile(_ sender: UIButton) {
        self.presenter.didTapEditProfileButton()
    }
    
    func inject(with presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension ProfileViewController: ProfileViewPresenterOutput {
    func presentEditProfileVC() {
        guard let editProfileVC = EditProfileViewBuilder.create() as? EditProfileViewController else { return }
        editProfileVC.profileImage = self.profileImageView.image ?? UIImage()
        editProfileVC.userName = self.nameLabel.text
        
        let navigationController = UINavigationController(rootViewController: editProfileVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
