//
//  EditProfileViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/25.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private var presenter: EditProfileViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopEditProfileButton))
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveEditProfileButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.rightBarButtonItem = saveItem
        self.navigationItem.title = "Edit Profile"
    }
    
    @objc func tapStopEditProfileButton() {
        self.presenter.didTapStopEditProfileButton()
    }

    @objc func tapSaveEditProfileButton() {
        self.presenter.didTapSaveEditProfileButton()
    }
    
    func inject(with presenter: EditProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension EditProfileViewController: EditProfileViewPresenterOutput {
    func dismissEditProfileVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
