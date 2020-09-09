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
    
    func didTapStopEditGroupButton()
    func didTapSaveEditGroupButton(groupName: String, profileImageData: Data)
    func didTapChangeGroupButton()
    
    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
}

protocol EditGroupViewPresenterOutput: class {
    func dismissEditGroupVC()
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
    func setDeleteAndSetDefaultImage()
}

final class EditGroupViewPresenter: EditGroupViewPresenterProtocol, EditGroupModelOutput {
    weak var view: EditGroupViewPresenterOutput!
    private var model: EditGroupModelProtocol
    
    init(model: EditGroupModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapStopEditGroupButton() {
        self.view.dismissEditGroupVC()
    }
    
    func didTapSaveEditGroupButton(groupName: String, profileImageData: Data) {
        
    }
    
    func didTapChangeGroupButton() {
        self.view.presentActionSheet()
    }
    
    func didTapChangeProfileButton() {
        self.view.presentActionSheet()
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
}
