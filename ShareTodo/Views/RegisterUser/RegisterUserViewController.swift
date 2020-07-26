//
//  RegisterUserViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import CropViewController

final class RegisterUserViewController: UIViewController {
    private var presenter: RegisterUserViewPresenterProtocol!
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var choseProfileImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var actionSheet = UIAlertController()
    let photoPickerVC = UIImagePickerController()
    
    let maxTextfieldLength = 15
    let usersImageViewWide: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRegisterLabel()
        self.setupProfileImageButton()
        self.setupChoseProfileImageButton()
        self.setupNameTextField()
        self.setupRegisterButton()
        self.setupActionSheet()
        self.setupPhotoPickerVC()
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
    
    func setupActionSheet() {
        self.actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.presenter.didTapTakePhotoAction()
        })
        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default, handler: { _ in
            self.presenter.didTapSelectPhotoAction()
        })
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive, handler: { _ in
            self.presenter.didTapDeletePhotoAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.actionSheet.addAction(takePhotoAction)
        self.actionSheet.addAction(selectPhotoAction)
        self.actionSheet.addAction(deletePhotoAction)
        self.actionSheet.addAction(cancelAction)
    }
    
    func setupPhotoPickerVC() {
        self.photoPickerVC.delegate = self
    }
    
    @IBAction func tapChoseProfileImageButton(_ sender: Any) {
        self.presenter.didTapChoseProfileImageButton()
    }
    
    func inject(with presenter: RegisterUserViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension RegisterUserViewController: RegisterUserViewPresenterOutput {
    func presentActionSheet() {
        self.present(self.actionSheet, animated: true, completion: nil)
    }
    
    func showUIImagePickerControllerAsCamera() {
        photoPickerVC.sourceType = .camera
        self.present(photoPickerVC, animated: true, completion: nil)
    }
    
    func showUIImagePickerControllerAsLibrary() {
        photoPickerVC.sourceType = .photoLibrary
        self.present(photoPickerVC, animated: true, completion: nil)
    }
}

extension RegisterUserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickerImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: .circular, image: pickerImage)
        cropController.aspectRatioPreset = .presetSquare
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        cropController.rotateButtonsHidden = false
        cropController.cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        cropController.doneButtonTitle = NSLocalizedString("Done", comment: "")
        cropController.cropView.cropBoxResizeEnabled = false
        cropController.delegate = self

        picker.dismiss(animated: true) {
            self.present(cropController, animated: true, completion: nil)
        }
    }
}

extension RegisterUserViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let resizeImage = image.resizeUIImage(width: self.usersImageViewWide, height: self.usersImageViewWide)
        self.profileImageButton.setImage(resizeImage, for: .normal)
        cropViewController.dismiss(animated: true, completion: nil)
    }
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
