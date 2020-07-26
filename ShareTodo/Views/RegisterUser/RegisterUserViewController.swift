//
//  RegisterUserViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class RegisterUserViewController: UIViewController {
    private var presenter: RegisterUserViewPresenterProtocol!
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var choseProfileImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let maxTextfieldLength = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRegisterLabel()
        self.setupProfileImageButton()
        self.setupChoseProfileImageButton()
        self.setupNameTextField()
        self.setupRegisterButton()
    }
    
    func setupRegisterLabel() {
        self.registerLabel.adjustsFontSizeToFitWidth = true
        self.registerLabel.minimumScaleFactor = 0.4
    }
    
    func setupProfileImageButton() {
        self.profileImageButton.layer.borderWidth = 0.25
        self.profileImageButton.layer.borderColor = UIColor.systemGray4.cgColor
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.width / 2
        self.profileImageButton.layer.masksToBounds = true
    }
    
    func setupChoseProfileImageButton() {
        self.choseProfileImageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.choseProfileImageButton.titleLabel?.minimumScaleFactor = 0.4
        self.choseProfileImageButton.layer.borderWidth = 0.25
    }
    
    func setupNameTextField() {
        self.nameTextField.placeholder = "Group Name"
        self.nameTextField.borderStyle = .none
        self.nameTextField.returnKeyType = .done
        self.nameTextField.delegate = self
        self.nameTextField.enablesReturnKeyAutomatically = true
    }
    
    func setupRegisterButton() {
        self.registerButton.backgroundColor = .systemTeal
        self.registerLabel.tintColor = .white
        self.registerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.registerButton.titleLabel?.minimumScaleFactor = 0.4
        self.registerButton.layer.cornerRadius = 8
        self.registerButton.layer.masksToBounds = true
        self.registerButton.isUserInteractionEnabled = true
    }
    
    @IBAction func tapChoseProfileImageButton(_ sender: Any) {
        
    }
    
    func inject(with presenter: RegisterUserViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension RegisterUserViewController: RegisterUserViewPresenterOutput {
    
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField, let text = textField.text else { return }
        if textField.markedTextRange == nil && text.count > maxTextfieldLength {
            textField.text = text.prefix(maxTextfieldLength).description
        }
    }
}
