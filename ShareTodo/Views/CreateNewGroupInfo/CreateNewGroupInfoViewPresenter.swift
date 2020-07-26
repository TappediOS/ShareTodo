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
}

final class CreateNewGroupInfoViewPresenter: CreateNewGroupInfoViewPresenterProtocol, CreateNewGroupInfoModelOutput {
    weak var view: CreateNewGroupInfoViewPresenterOutput!
    private var model: CreateNewGroupInfoModelProtocol
    
    init(model: CreateNewGroupInfoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapGroupButton(selectedUsers: [User], groupName: String, groupTask: String, groupImageData: Data) {
        self.model.createGroup(selectedUsers: selectedUsers, groupName: groupName, groupTask: groupTask, groupImageData: groupImageData)
    }
    
    func didTapGroupImageView() {
        self.view.presentActionSheet()
    }
    
    func didTapTakePhotoAction() {
        self.view.showUIImagePickerControllerAsCamera()
    }
    
    func didTapSelectPhotoAction() {
        self.view.showUIImagePickerControllerAsLibrary()
    }
    
    func didTapDeletePhotoAction() {
        
    }
    
    func successCreateGroup() {
        self.view.dismissCreateNewGroupInfoVC()
    }
}
