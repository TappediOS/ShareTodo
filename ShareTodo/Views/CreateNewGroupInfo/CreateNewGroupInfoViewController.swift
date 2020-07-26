//
//  CreateNewGroupInfoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class CreateNewGroupInfoViewController: UIViewController {
    private var presenter: CreateNewGroupInfoViewPresenterProtocol!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskTextField: UITextField!
    
    let maxTextfieldLength = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGroupImageView()
        self.setupGroupNameTextField()
        self.setupTaskLabel()
        self.setupTaskTextField()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.groupNameTextField.addBorderBottom(borderWidth: 1, color: .systemGray)
        self.taskTextField.addBorderBottom(borderWidth: 1, color: .systemGray)
    }
    
    func setupGroupImageView() {
        self.groupImageView.image = UIImage(systemName: "person") ?? UIImage()
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
    }
    
    func setupGroupNameTextField() {
        self.groupNameTextField.placeholder = "Group Name"
        self.groupNameTextField.borderStyle = .none
        self.groupNameTextField.returnKeyType = .done
        self.groupNameTextField.delegate = self
        self.groupNameTextField.enablesReturnKeyAutomatically = true
    }
    
    func setupTaskLabel() {
        self.taskLabel.adjustsFontSizeToFitWidth = true
        self.taskLabel.minimumScaleFactor = 0.4
    }
    
    func setupTaskTextField() {
        self.taskTextField.placeholder = "Group Task"
        self.taskTextField.borderStyle = .none
        self.taskTextField.returnKeyType = .done
        self.taskTextField.delegate = self
        self.taskTextField.enablesReturnKeyAutomatically = true
    }
    
    func inject(with presenter: CreateNewGroupInfoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension CreateNewGroupInfoViewController: CreateNewGroupInfoViewPresenterOutput {
    
}

extension CreateNewGroupInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.groupNameTextField.resignFirstResponder()
        self.taskTextField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField, let text = textField.text else { return }
        if textField.markedTextRange == nil && text.count > maxTextfieldLength {
            textField.text = text.prefix(maxTextfieldLength).description
        }
    }
}
