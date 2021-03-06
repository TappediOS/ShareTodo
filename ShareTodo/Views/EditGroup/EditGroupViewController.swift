//
//  EditGroupViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import CropViewController
import Nuke

protocol EditGroupViewControllerDelegate: class {
    func reaveGroupFinished(_ editprofileViewController: EditGroupViewController)
    func editGroupViewControllerDidFinish(group: Group, groupUsers: [User])
    func editGroupViewControllerDidCanceled(_ EditGroupViewController: EditGroupViewController)
}

final class EditGroupViewController: UIViewController {
    private var presenter: EditGroupViewPresenterProtocol!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var membersLabel: UILabel! { didSet { self.membersLabel.text = R.string.localizable.members() }}
    @IBOutlet weak var selectedUsersAndMeCollectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var inviteUsersButton: UIButton!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var leaveGroupButtonButtomConstraint: NSLayoutConstraint!
    
    var editProfileActionSheet = UIAlertController()
    var leaveGroupActionSheet = UIAlertController()
    var pickupUserActionSheet = UIAlertController()
    var removeUserActionSheet = UIAlertController()
    let photoPickerVC = UIImagePickerController()
    
    let selectedUsersAndMeCollectionViewCellId = "SelectedUsersAndMeCollectionViewCell"
    
    let maxTextfieldLength = 40
    let usersImageViewWide: CGFloat = 100
    
    // MARK: - Delegate
    weak var delegate: EditGroupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupGroupImageView()
        self.setupGroupNameTextField()
        self.setupTaskLabel()
        self.setupTaskTextField()
        self.setupPhotoImageView()
        self.setupSelectedUsersCollectionView()
        self.setupEditProfileActionSheet()
        self.setupLeaveGroupActionSheet()
        self.setupPickupUserActionSheet()
        self.setupLeaveUserActionSheet()
        self.setupPhotoPickerVC()
        self.setupInviteUsersButton()
        self.setupLeaveGroupButton()
        self.setupNotificationCenter()
        
        self.presenter.didViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.groupNameTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.taskTextField.addBorderBottom(borderWidth: 0.5, color: .systemGray2)
        self.selectedUsersAndMeCollectionView.addBorderBottom(borderWidth: 0.25, color: .systemGray3)
        self.selectedUsersAndMeCollectionView.addBorderTop(borderWidth: 0.25, color: .systemGray3)
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopEditGroupButton))
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveEditGroupButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.rightBarButtonItem = saveItem
        self.navigationItem.leftBarButtonItem?.tintColor = .systemPink
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        self.navigationItem.title = R.string.localizable.editGroup()
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
        self.groupNameTextField.placeholder = R.string.localizable.groupName()
        self.groupNameTextField.borderStyle = .none
        self.groupNameTextField.returnKeyType = .done
        self.groupNameTextField.delegate = self
        self.groupNameTextField.enablesReturnKeyAutomatically = true
    }
    
    func setupTaskLabel() {
        self.taskLabel.text = R.string.localizable.task()
        self.taskLabel.adjustsFontSizeToFitWidth = true
        self.taskLabel.minimumScaleFactor = 0.4
    }
    
    func setupTaskTextField() {
        self.taskTextField.placeholder = R.string.localizable.groupTask()
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
    
    func setupEditProfileActionSheet() {
        self.editProfileActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.editProfileActionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.editProfileActionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
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
        
        self.editProfileActionSheet.addAction(takePhotoAction)
        self.editProfileActionSheet.addAction(selectPhotoAction)
        self.editProfileActionSheet.addAction(deletePhotoAction)
        self.editProfileActionSheet.addAction(cancelAction)
    }
    
    func setupLeaveGroupActionSheet() {
        self.leaveGroupActionSheet = UIAlertController(title: R.string.localizable.leaveGroup(), message: R.string.localizable.leaveGroupMessage(), preferredStyle: .alert)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.leaveGroupActionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.leaveGroupActionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        let reaveAction = UIAlertAction(title: R.string.localizable.leave(), style: .destructive, handler: { _ in
            self.presenter.didTapLeaveGroupAction()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
        
        self.leaveGroupActionSheet.addAction(reaveAction)
        self.leaveGroupActionSheet.addAction(cancelAction)
    }
    
    func setupPickupUserActionSheet() {
        self.pickupUserActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.pickupUserActionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.pickupUserActionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        let removeAtion = UIAlertAction(title: R.string.localizable.remove(), style: .destructive, handler: { _ in
            self.presenter.didTapPickupActionSheetRemoveAction()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            self.presenter.didTapCancelRemoveUser()
        })
        
        self.pickupUserActionSheet.addAction(removeAtion)
        self.pickupUserActionSheet.addAction(cancelAction)
    }
    
    func setupLeaveUserActionSheet() {
        self.removeUserActionSheet = UIAlertController(title: R.string.localizable.removeUser(), message: R.string.localizable.removeUserMessage(), preferredStyle: .alert)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.removeUserActionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            self.removeUserActionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        let removeAction = UIAlertAction(title: R.string.localizable.remove(), style: .destructive, handler: { _ in
            self.presenter.didTapRemoveUserAction()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            self.presenter.didTapCancelRemoveUser()
        })
        
        self.removeUserActionSheet.addAction(removeAction)
        self.removeUserActionSheet.addAction(cancelAction)
    }
    
    func setupPhotoPickerVC() {
        self.photoPickerVC.delegate = self
    }
    
    func setupInviteUsersButton() {
        self.inviteUsersButton.setTitle(R.string.localizable.inviteUser(), for: .normal)
        self.inviteUsersButton.backgroundColor = .systemGreen
        self.inviteUsersButton.tintColor = .white
        self.inviteUsersButton.layer.cornerRadius = 8
        self.inviteUsersButton.layer.masksToBounds = true
    }
    
    func setupLeaveGroupButton() {
        self.leaveGroupButton.setTitle(R.string.localizable.leaveGroup(), for: .normal)
        self.leaveGroupButton.backgroundColor = .systemRed
        self.leaveGroupButton.tintColor = .white
        self.leaveGroupButton.layer.cornerRadius = 8
        self.leaveGroupButton.layer.masksToBounds = true
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.groupNameTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification, object: self.taskTextField)
    }
    
    @objc func tapStopEditGroupButton() {
        self.presenter.didTapStopEditGroupButton()
    }
    
    @objc func tapSaveEditGroupButton() {
        guard let groupName = groupNameTextField.text, let groupTask = taskTextField.text else { return }
        guard !groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.presenter.didTapSaveEditGroupButton(isEmptyTextField: true)
            return
        }
        guard !groupTask.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.presenter.didTapSaveEditGroupButton(isEmptyTextField: true)
            return
        }
        
        let data = self.groupImageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
        self.presenter.didTapSaveEditGroupButton(selectedUsers: self.presenter.groupUsers, groupName: groupName, groupTask: groupTask, groupImageData: data)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func tapGroupImageView(_ sender: UITapGestureRecognizer) {
        self.presenter.didTapGroupImageView()
    }
    
    @IBAction func tapInviteUsersButton(_ sender: Any) {
        self.presenter.didTapInviteUsersButton()
    }
    
    @IBAction func tapLeaveGroupButton(_ sender: Any) {
        self.presenter.didTapLeaveGroupButton()
    }
    
    func inject(with presenter: EditGroupViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension EditGroupViewController: EditGroupViewPresenterOutput {
    func setCurrnetGroupImage() {
        DispatchQueue.main.async {
            guard let url = URL(string: self.presenter.group.profileImageURL ?? "") else {
                self.groupImageView.image = R.image.groupDefaultImage()
                return
            }
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25),
                                              failureImage: R.image.groupDefaultImage())
            
            loadImage(with: url, options: options, into: self.groupImageView, progress: nil, completion: nil)
        }
    }
    
    func setGroupName() {
        DispatchQueue.main.async {
            self.groupNameTextField.text = self.presenter.group.name
        }
    }
    
    func setGroupTask() {
        DispatchQueue.main.async {
            self.taskTextField.text = self.presenter.group.task
        }
    }
    
    func setRedColorPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemPink.withAlphaComponent(0.55),
                                                          .font: UIFont.boldSystemFont(ofSize: 14)]
        self.taskTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.groupTask(), attributes: attributes)
        self.groupNameTextField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.groupName(), attributes: attributes)
    }
    
    func reloadSelectedUsersAndMeCollectionView() {
        DispatchQueue.main.async {
            self.selectedUsersAndMeCollectionView.reloadData()
        }
    }
    
    func dismissEditGroupVC_Delegate_Finished() {
        self.delegate?.editGroupViewControllerDidFinish(group: self.presenter.group, groupUsers: self.presenter.groupUsers)
    }
    
    func dismissEditGroupVC_Delegate_Leaved() {
        self.delegate?.reaveGroupFinished(self)
    }
    
    func dismissEditGroupVC_Delegate_Canceled() {
        self.delegate?.editGroupViewControllerDidCanceled(self)
    }
    
    func presentActionSheet() {
        self.present(self.editProfileActionSheet, animated: true, completion: nil)
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
        DispatchQueue.main.async { self.groupImageView.image = R.image.groupDefaultImage() }
    }
    
    func showSelectInviteUsersVC() {
        guard let createNewGroupVC = CreateNewGroupViewBuilder.create(searchUsersType: .inviteUsers) as? CreateNewGroupViewController else { return }
        let navigationController = UINavigationController(rootViewController: createNewGroupVC)
        navigationController.modalPresentationStyle = .fullScreen
        createNewGroupVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showPickupUserActionSheet(pickupUserName: String) {
        self.pickupUserActionSheet.title = pickupUserName
        self.present(self.pickupUserActionSheet, animated: true, completion: nil)
    }
    
    func showLeaveGroupAleartView() {
        self.present(self.leaveGroupActionSheet, animated: true, completion: nil)
    }
    
    func showRemoveUserAleartView(mayRemoveUserName: String) {
        self.removeUserActionSheet.title = R.string.localizable.remove_colon() + mayRemoveUserName
        self.present(self.removeUserActionSheet, animated: true, completion: nil)
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

extension EditGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.groupUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedUsersAndMeCollectionViewCellId, for: indexPath) as! SelectedUsersAndMeCollectionViewCell

        cell.configure(with: self.presenter.groupUsers[indexPath.item])
        cell.tapSelectedUsersAndMeCellAction = { [weak self] in
            guard let self = self else { return }
            self.presenter.tapSelectedUsersAndMeProfileImage(index: indexPath.item)
        }
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

extension EditGroupViewController: CreateNewGroupViewControllerDelegate {
    func inviteUserDidFinish(inviteUsers: [User]) {
        self.dismiss(animated: true, completion: nil)
        self.presenter.didSelectedInviteUsers(inviteUsers: inviteUsers)
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
        cropController.cancelButtonTitle = R.string.localizable.cancel()
        cropController.doneButtonTitle = R.string.localizable.done()
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
        let resizeImage = image.resizeUIImage(width: self.usersImageViewWide, height: self.usersImageViewWide)
        self.groupImageView.image = resizeImage
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension EditGroupViewController: UITextFieldDelegate {
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
