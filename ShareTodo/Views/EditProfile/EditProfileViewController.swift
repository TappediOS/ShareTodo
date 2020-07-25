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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var chageProfileButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var profileImage = UIImage()
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupProfileImageView()
        self.setupChageProfileButton()
        self.setupNameTextField()
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopEditProfileButton))
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveEditProfileButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.rightBarButtonItem = saveItem
        self.navigationItem.title = "Edit Profile"
    }
    
    func setupProfileImageView() {
        self.profileImageView.image = self.profileImage
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.layer.masksToBounds = true
    }
    
    func setupChageProfileButton() {
        self.chageProfileButton.setTitle("Edit Profile", for: .normal)
        self.chageProfileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.chageProfileButton.titleLabel?.minimumScaleFactor = 0.4
    }
    
    func setupNameTextField() {
        self.nameTextField.text = userName ?? ""
    }
    
    @objc func tapStopEditProfileButton() {
        self.presenter.didTapStopEditProfileButton()
    }

    @objc func tapSaveEditProfileButton() {
        self.presenter.didTapSaveEditProfileButton()
    }
    
    @IBAction func tapChangeProfileButton(_ sender: Any) {
        self.presenter.didTapChangeProfileButton()
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
    
    func presentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.didTapTakePhotoAction()
        })
        
        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.didTapSelectPhotoAction()
        })
        
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive, handler: { (action: UIAlertAction!) in
            self.presenter.didTapDeletePhotoAction()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(deletePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showUIImagePickerControllerAsCamera() {
        let photoPickerVC = UIImagePickerController()
        photoPickerVC.sourceType = .camera
        photoPickerVC.delegate = self
        self.present(photoPickerVC, animated: true, completion: nil)
    }
    
    func showUIImagePickerControllerAsLibrary() {
        let photoPickerVC = UIImagePickerController()
        photoPickerVC.sourceType = .photoLibrary
        photoPickerVC.delegate = self
        self.present(photoPickerVC, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickerImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        picker.dismiss(animated: true)
    }
}
