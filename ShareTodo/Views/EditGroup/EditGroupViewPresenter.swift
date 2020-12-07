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
    func didTapPickupActionSheetRemoveAction()
    func didTapRemoveUserAction()
    func didTapCancelRemoveUser()
    
    func didSelectedInviteUsers(inviteUsers: [User])
    
    func tapSelectedUsersAndMeProfileImage(index: Int)
}

protocol EditGroupViewPresenterOutput: class {
    func setCurrnetGroupImage()
    func setGroupName()
    func setGroupTask()
    func setRedColorPlaceholder()
    func reloadSelectedUsersAndMeCollectionView()
    func dismissEditGroupVC_Delegate_Leaved()
    func dismissEditGroupVC_Delegate_Finished()
    func dismissEditGroupVC_Delegate_Canceled()
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func setDeleteAndSetDefaultImage()
    func showSelectInviteUsersVC()
    func showLeaveGroupAleartView()
    func showPickupUserActionSheet(pickupUserName: String)
    func showRemoveUserAleartView(mayRemoveUserName: String)
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
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
        self.view.dismissEditGroupVC_Delegate_Canceled()
        self.view.impactFeedbackOccurred()
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
        self.view.impactFeedbackOccurred()
    }
    
    func didTapChangeProfileButton() {
        self.view.presentActionSheet()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapGroupImageView() {
        self.view.presentActionSheet()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapInviteUsersButton() {
        self.view.showSelectInviteUsersVC()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapLeaveGroupButton() {
        self.view.showLeaveGroupAleartView()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapTakePhotoAction() {
        self.view.showUIImagePickerControllerAsCamera()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapSelectPhotoAction() {
        self.view.showUIImagePickerControllerAsLibrary()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapDeletePhotoAction() {
        self.view.setDeleteAndSetDefaultImage()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapLeaveGroupAction() {
        self.model.leaveGroup()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapRemoveUserAction() {
        self.model.removeUser()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapCancelRemoveUser() {
        self.model.resetMayRemoveUserUID()
    }
    
    func didSelectedInviteUsers(inviteUsers: [User]) {
        self.model.inviteUsers(inviteUsers: inviteUsers)
    }
    
    func didTapPickupActionSheetRemoveAction() {
        guard let uid = model.mayRemoveUserUID else { return }
        guard let removedUser = model.groupUsers.filter({ $0.id == uid }).first else { return }
        self.view.showRemoveUserAleartView(mayRemoveUserName: removedUser.name)
        self.view.impactFeedbackOccurred()
    }

    func tapSelectedUsersAndMeProfileImage(index: Int) {
        guard model.selectedUserEqualMe(index: index) == false else { return }
        guard let selectedUser = model.getSelectedUser(index: index) else { return }
        guard let selectedUsersUID = selectedUser.id else { return }
        self.model.setMayRemoveUserUID(uid: selectedUsersUID)
        self.view.showPickupUserActionSheet(pickupUserName: selectedUser.name)
        self.view.impactFeedbackOccurred()
    }
    
    func successSaveGroup() {
        self.view.dismissEditGroupVC_Delegate_Finished()
        self.view.noticeFeedbackOccurredSuccess()
    }
    
    func successRemoveUser() {
        self.view.reloadSelectedUsersAndMeCollectionView()
        self.view.noticeFeedbackOccurredSuccess()
    }
    
    func successLeaveGroup() {
        self.view.dismissEditGroupVC_Delegate_Leaved()
        self.view.noticeFeedbackOccurredSuccess()
    }
    
    func successInviteUsers() {
        self.view.reloadSelectedUsersAndMeCollectionView()
        self.view.noticeFeedbackOccurredSuccess()
    }
}
