//
//  EditGroupViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol EditGroupViewPresenterProtocol {
    var view: EditGroupViewPresenterOutput! { get set }
    var group: Group { get }
    var groupUsers: [User] { get }
    
    func didViewDidLoad()
    func didTapStopEditGroupButton()
    func didTapSaveEditGroupButton(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data)
    func didTapSaveEditGroupButton(isEmptyTextField: Bool)
    func didTapChangeGroupButton()
    func didTapGroupImageView()
    func didTapInviteUsersButton()
    func didTapLeaveGroupButton()
    
    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
    func didTapLeaveGroupAction()
    func didTapRemoveUserAction()
    func didTapCancelRemoveUser()
    
    func tapSelectedUsersAndMeProfileImage(index: Int)
}

protocol EditGroupViewPresenterOutput: class {
    func setCurrnetGroupImage()
    func setGroupName()
    func setGroupTask()
    func setRedColorPlaceholder()
    func reloadSelectedUsersAndMeCollectionView()
    func dismissEditGroupVC()
    func dismissEditGroupVC_Delegate()
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func setDeleteAndSetDefaultImage()
    func showSelectInviteUsersVC()
    func showLeaveGroupAleartView()
    func showLeaveUserAleartView()
}

final class EditGroupViewPresenter: EditGroupViewPresenterProtocol, EditGroupModelOutput {
    weak var view: EditGroupViewPresenterOutput!
    private var model: EditGroupModelProtocol
    var group: Group { return self.model.group }
    var groupUsers: [User] { return self.model.groupUsers }
    var numberOfGroupUsers: Int { return self.model.groupUsers.count }
    
    init(model: EditGroupModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.view.setCurrnetGroupImage()
        self.view.setGroupName()
        self.view.setGroupTask()
    }
    
    func didTapStopEditGroupButton() {
        self.view.dismissEditGroupVC()
    }
    
    func didTapSaveEditGroupButton(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data) {
        self.model.updateGroup(selectedUsers: selectedUsers, groupName: groupName, groupTask: groupTask, groupImageData: groupImageData)
    }
    
    func didTapSaveEditGroupButton(isEmptyTextField: Bool) {
        guard isEmptyTextField else { return }
        
        self.view.setRedColorPlaceholder()
    }
    
    func didTapChangeGroupButton() {
        self.view.presentActionSheet()
    }
    
    func didTapChangeProfileButton() {
        self.view.presentActionSheet()
    }
    
    func didTapGroupImageView() {
        self.view.presentActionSheet()
    }
    
    func didTapInviteUsersButton() {
        self.view.showSelectInviteUsersVC()
    }
    
    func didTapLeaveGroupButton() {
        self.view.showLeaveGroupAleartView()
    }
    
    func didTapTakePhotoAction() {
        self.view.showUIImagePickerControllerAsCamera()
    }
    
    func didTapSelectPhotoAction() {
        self.view.showUIImagePickerControllerAsLibrary()
    }
    
    func didTapDeletePhotoAction() {
        self.view.setDeleteAndSetDefaultImage()
    }
    
    func didTapLeaveGroupAction() {
        self.model.leaveGroup()
    }
    
    func didTapRemoveUserAction() {
        self.model.removeUser()
    }
    
    func didTapCancelRemoveUser() {
        self.model.resetMayRemoveUserUID()
    }

    func tapSelectedUsersAndMeProfileImage(index: Int) {
        guard model.selectedUserEqualMe(index: index) == false else { return }
        guard let selectedUser = model.getSelectedUsersUID(index: index) else { return }
        self.model.setMayRemoveUserUID(uid: selectedUser)
        self.view.showLeaveUserAleartView()
    }
    
    func successSaveGroup() {
        self.view.dismissEditGroupVC()
    }
    
    func successRemoveUser() {
        self.view.reloadSelectedUsersAndMeCollectionView()
    }
    
    func successLeaveGroup() {
        self.view.dismissEditGroupVC_Delegate()
    }
}
