//
//  EditProfileViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/25.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol EditProfileViewPresenterProtocol {
    var view: EditProfileViewPresenterOutput! { get set }
    
    func didTapStopEditProfileButton()
    func didTapSaveEditProfileButton(userName: String, profileImageData: Data)
    func didTapChangeProfileButton()

    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
    func didTapSaveAction()
    func didTapDiscardChangesAction()
    func didCropedProfileImageView()
    func didBeginTextFieldEditing()
    func didEndTextFieldEditing()
}

protocol EditProfileViewPresenterOutput: class {
    func dismissEditProfileVC()
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func setDeleteAndSetDefaultImage()
    func turnOnIsModalInPresentation()
    func turnOnNavigationBarRightItem()
    func turnOffNavigationBarRightItem()
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class EditProfileViewPresenter: EditProfileViewPresenterProtocol, EditProfileModelOutput {
    weak var view: EditProfileViewPresenterOutput!
    private var model: EditProfileModelProtocol
    
    init(model: EditProfileModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapStopEditProfileButton() {
        self.view.dismissEditProfileVC()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapSaveEditProfileButton(userName: String, profileImageData: Data) {
        self.model.saveUser(userName: userName, profileImageData: profileImageData)
        self.view.impactFeedbackOccurred()
    }
    
    func didTapChangeProfileButton() {
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
        self.view.turnOnIsModalInPresentation()
        self.view.setDeleteAndSetDefaultImage()
        self.view.impactFeedbackOccurred()
    }
    
    func didTapSaveAction() {
        
    }
    
    func didTapDiscardChangesAction() {
        self.view.dismissEditProfileVC()
        self.view.impactFeedbackOccurred()
    }
    
    func didCropedProfileImageView() {
        self.view.turnOnIsModalInPresentation()
        self.view.impactFeedbackOccurred()
    }
    
    func didBeginTextFieldEditing() {
        self.view.turnOffNavigationBarRightItem()
    }
    
    func didEndTextFieldEditing() {
        self.view.turnOnNavigationBarRightItem()
        self.view.turnOnIsModalInPresentation()
    }
    
    func successSaveUser() {
        self.view.dismissEditProfileVC()
        self.view.noticeFeedbackOccurredSuccess()
    }
}
