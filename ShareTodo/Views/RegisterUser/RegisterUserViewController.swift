//
//  RegisterUserViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import CropViewController
import SCLAlertView

final class RegisterUserViewController: UIViewController {
    private var presenter: RegisterUserViewPresenterProtocol!
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var choseProfileImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var profileImage = R.image.defaultProfileImage()
    
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
        self.setupNotificationCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.nameTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
    }
    
    func setupRegisterLabel() {
        self.registerLabel.text = R.string.localizable.register()
        self.registerLabel.adjustsFontSizeToFitWidth = true
        self.registerLabel.minimumScaleFactor = 0.4
    }
    
    func setupProfileImageButton() {
        self.profileImageButton.setImage(self.profileImage, for: .normal)
        self.profileImageButton.layer.borderWidth = 0.25
        self.profileImageButton.layer.borderColor = UIColor.systemGray4.cgColor
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.width / 2
        self.profileImageButton.layer.masksToBounds = true
    }
    
    func setupChoseProfileImageButton() {
        self.choseProfileImageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.choseProfileImageButton.titleLabel?.minimumScaleFactor = 0.4
    }
    
    func setupNameTextField() {
        self.nameTextField.placeholder = R.string.localizable.userName()
        self.nameTextField.borderStyle = .none
        self.nameTextField.returnKeyType = .done
        self.nameTextField.delegate = self
        self.nameTextField.enablesReturnKeyAutomatically = true
    }
    
    func setupRegisterButton() {
        self.registerButton.backgroundColor = .systemGreen
        self.registerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.registerButton.titleLabel?.minimumScaleFactor = 0.4
        self.registerButton.layer.cornerRadius = 8
        self.registerButton.layer.masksToBounds = true
        self.registerButton.isUserInteractionEnabled = true
    }
    
    func setupActionSheet() {
        self.actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.actionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        let takePhotoAction = UIAlertAction(title: R.string.localizable.takePhoto(), style: .default, handler: { _ in
            self.presenter.didTapTakePhotoAction()
        })
        let selectPhotoAction = UIAlertAction(title: R.string.localizable.selectPhoto(), style: .default, handler: { _ in
            self.presenter.didTapSelectPhotoAction()
        })
        let deletePhotoAction = UIAlertAction(title: R.string.localizable.deletePhoto(), style: .destructive, handler: { _ in
            self.presenter.didTapDeletePhotoAction()
        })
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        
        self.actionSheet.addAction(takePhotoAction)
        self.actionSheet.addAction(selectPhotoAction)
        self.actionSheet.addAction(deletePhotoAction)
        self.actionSheet.addAction(cancelAction)
    }
    
    func setupPhotoPickerVC() {
        self.photoPickerVC.delegate = self
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.nameTextField)
    }
    
    @IBAction func tapChoseProfileImageButton(_ sender: Any) {
        self.presenter.didTapChoseProfileImageButton()
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        guard let userName = self.nameTextField.text else { return }
        guard !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.nameTextField.text = String()
            let stringAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemRed.withAlphaComponent(0.5)]
            self.nameTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.userName(), attributes: stringAttributes)
            return
        }
        
        guard let profileImageData = self.profileImage?.jpegData(compressionQuality: 0.5) else { return }
        self.presenter.didTapRegisterButton(userName: userName, profileImageData: profileImageData)
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
    
    func setDeleteAndSetDefaultImage() {
        DispatchQueue.main.async {
            self.profileImage = R.image.defaultProfileImage()
            self.profileImageButton.setImage(self.profileImage, for: .normal)
        }
    }
    
    func presentMainTabBarController() {
        DispatchQueue.main.async {
            let mainTabBarController = MainTabBarViewBuilder.create()
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true, completion: nil)
        }
    }
    
    func enableRegisterButton() {
        self.registerButton.isEnabled = true
    }
    
    func disableRegisterButton() {
        self.registerButton.isEnabled = false
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
        cropController.cancelButtonTitle = R.string.localizable.cancel()
        cropController.doneButtonTitle = R.string.localizable.done()
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
        
        self.profileImage = resizeImage
        self.profileImageButton.setImage(self.profileImage, for: .normal)
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
