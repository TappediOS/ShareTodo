//
//  CreateNewGroupInfoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol CreateNewGroupInfoViewPresenterProtocol {
    var view: CreateNewGroupInfoViewPresenterOutput! { get set }
    
    func didViewDidLoad()
    func didTapGroupImageView()
    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
    
    func didTapGroupButton(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data)
}

protocol CreateNewGroupInfoViewPresenterOutput: class {
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func dismissCreateNewGroupInfoVC()
    func setDeleteAndSetDefaultImage()
    func reloadCollectionView(addUser: User)
    func enableRightBarButtonItem()
    func disEnableRightBarButtonItem()
    
    func showErrorAleartView(error: Error)
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class CreateNewGroupInfoViewPresenter: CreateNewGroupInfoViewPresenterProtocol, CreateNewGroupInfoModelOutput {
    weak var view: CreateNewGroupInfoViewPresenterOutput!
    private var model: CreateNewGroupInfoModelProtocol
    
    init(model: CreateNewGroupInfoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchUser()
    }
    
    func didTapGroupButton(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data) {
        self.view.disEnableRightBarButtonItem()
        self.model.createGroup(selectedUsers: selectedUsers, groupName: groupName, groupTask: groupTask, groupImageData: groupImageData)
        self.view.impactFeedbackOccurred()
    }
    
    func didTapGroupImageView() {
        self.view.presentActionSheet()
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
    
    func successCreateGroup() {
        self.view.dismissCreateNewGroupInfoVC()
        self.view.noticeFeedbackOccurredSuccess()
    }
    
    func successFetchUser(user: User) {
        self.view.reloadCollectionView(addUser: user)
    }
    
    func error(error: Error) {
        self.view.enableRightBarButtonItem()
        self.view.showErrorAleartView(error: error)
        self.view.noticeFeedbackOccurredError()
    }
}
