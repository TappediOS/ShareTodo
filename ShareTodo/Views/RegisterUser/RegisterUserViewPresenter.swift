//
//  RegisterUserViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol RegisterUserViewPresenterProtocol {
    var view: RegisterUserViewPresenterOutput! { get set }
    
    func didTapChoseProfileImageButton()
    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
    func didTapRegisterButton(userName: String, profileImageData: Data)
}

protocol RegisterUserViewPresenterOutput: class {
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func setDeleteAndSetDefaultImage()
    func presentMainTabBarController()
    func impactFeedbackOccurred()
    func noticeFeedbackOccurredError()
    func noticeFeedbackOccurredSuccess()
}

final class RegisterUserViewPresenter: RegisterUserViewPresenterProtocol, RegisterUserModelOutput {
    weak var view: RegisterUserViewPresenterOutput!
    private var model: RegisterUserModelProtocol
    
    init(model: RegisterUserModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapChoseProfileImageButton() {
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
    
    func didTapRegisterButton(userName: String, profileImageData: Data) {
        self.model.registerUser(userName: userName, profileImageData: profileImageData)
        self.view.impactFeedbackOccurred()
    }
    
    func successRegisterUser() {
        self.view.presentMainTabBarController()
        self.view.noticeFeedbackOccurredSuccess()
    }
}
