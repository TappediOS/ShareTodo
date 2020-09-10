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
    
    let selectedUsersAndMeCollectionViewCellId = "SelectedUsersAndMeCollectionViewCell"
    var selectedUsersArray: [User] = Array()
    
    let maxTextfieldLength = 40
    let usersImageViewWide: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupGroupImageView()
        self.setupGroupNameTextField()
        self.setupTaskLabel()
        self.setupTaskTextField()
        self.setupPhotoImageView()
        self.setupSelectedUsersCollectionView()
        self.setupActionSheet()
        self.setupPhotoPickerVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.groupNameTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.taskTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.selectedUsersAndMeCollectionView.addBorderBottom(borderWidth: 0.25, color: .systemGray3)
        self.selectedUsersAndMeCollectionView.addBorderTop(borderWidth: 0.25, color: .systemGray3)
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
    
    func setupGroupImageView() {
        self.groupImageView.image = R.image.groupDefaultImage()
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
        self.groupImageView.isUserInteractionEnabled = true
        self.groupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGroupImageView(_:))))
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
    
    func setupPhotoImageView() {
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.width / 2
        self.photoImageView.layer.masksToBounds = false
        self.photoImageView.layer.shadowColor = UIColor.black.cgColor
        self.photoImageView.layer.shadowOffset = CGSize(width: 2.75, height: 2.75)
        self.photoImageView.layer.shadowOpacity = 0.7
        self.photoImageView.layer.shadowRadius = 8.25
    }
    
    func setupSelectedUsersCollectionView() {
        self.selectedUsersAndMeCollectionView.alwaysBounceHorizontal = true
        self.selectedUsersAndMeCollectionView.collectionViewLayout.invalidateLayout()
        self.selectedUsersAndMeCollectionView.delegate = self
        self.selectedUsersAndMeCollectionView.dataSource = self
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
    
    @objc func tapGroupImageView(_ sender: UITapGestureRecognizer) {
        self.presenter.didTapGroupImageView()
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

extension EditGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
