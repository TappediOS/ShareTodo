//
//  EditGroupViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import CropViewController

final class EditGroupViewController: UIViewController {
    private var presenter: EditGroupViewPresenterProtocol!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var selectedUsersAndMeCollectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    
    var actionSheet = UIAlertController()
    let photoPickerVC = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupActionSheet()
        self.setupPhotoPickerVC()
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopEditProfileButton))
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveEditProfileButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.rightBarButtonItem = saveItem
        self.navigationItem.leftBarButtonItem?.tintColor = .systemPink
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        self.navigationItem.title = "Edit Group"
    }
    
    func setupActionSheet() {
        self.actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.actionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }
        
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
    
    @objc func tapStopEditProfileButton() {
        self.presenter.didTapStopEditGroupButton()
    }

    @objc func tapSaveEditProfileButton() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func inject(with presenter: EditGroupViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension EditGroupViewController: EditGroupViewPresenterOutput {
    func dismissEditGroupVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        //TODO:- デフォルトの画像をセットすること
        //DispatchQueue.main.async { self.profileImageView.image = R.image. }
    }
    
}

extension EditGroupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension EditGroupViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //TODO:- risizeしてセットすること
        //let resizeImage = image.resizeUIImage(width: self.usersImageViewWide, height: self.usersImageViewWide)
        //self.profileImageView.image = resizeImage
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension EditGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //TODO:- textFieldを削除すること
        //self.nameTextField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField, let text = textField.text else { return }
        //TODO:- グループ名の最大値を設定すること
        //if textField.markedTextRange == nil && text.count > maxTextfieldLength {
        //    textField.text = text.prefix(maxTextfieldLength).description
        //}
    }
}
