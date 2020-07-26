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
    @IBOutlet weak var selectedUsersAndMeCollectionView: UICollectionView!
    
    let selectedUsersAndMeCollectionViewCellId = "SelectedUsersAndMeCollectionViewCell"
    var selectedUsersArray: [User] = Array()
    let maxTextfieldLength = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addMeInSelectedUsersArray()
        self.setupGroupImageView()
        self.setupGroupNameTextField()
        self.setupTaskLabel()
        self.setupTaskTextField()
        self.setupSelectedUsersCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.groupNameTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.taskTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.selectedUsersAndMeCollectionView.addBorderBottom(borderWidth: 0.25, color: .systemGray3)
        self.selectedUsersAndMeCollectionView.addBorderTop(borderWidth: 0.25, color: .systemGray3)
    }
    
    func addMeInSelectedUsersArray() {
        selectedUsersArray.insert(User(id: "ss", name: "Me", profileImageURL: nil), at: 0)
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
    
    func setupSelectedUsersCollectionView() {
        self.selectedUsersAndMeCollectionView.collectionViewLayout.invalidateLayout()
        self.selectedUsersAndMeCollectionView.delegate = self
        self.selectedUsersAndMeCollectionView.dataSource = self
    }
    
    func inject(with presenter: CreateNewGroupInfoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension CreateNewGroupInfoViewController: CreateNewGroupInfoViewPresenterOutput {
    
}

extension CreateNewGroupInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedUsersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedUsersAndMeCollectionViewCellId, for: indexPath) as! SelectedUsersAndMeCollectionViewCell

        cell.configure(with: self.selectedUsersArray[indexPath.item])
        
        cell.profileImageView.image = UIImage(systemName: "bolt.circle.fill")
       
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10)
    }
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
