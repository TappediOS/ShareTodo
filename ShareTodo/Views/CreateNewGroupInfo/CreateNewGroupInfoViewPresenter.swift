//
//  CreateNewGroupInfoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol CreateNewGroupInfoViewPresenterProtocol {
    var view: CreateNewGroupInfoViewPresenterOutput! { get set }
    
    func didTapGroupImageView()
    func didTapTakePhotoAction()
    func didTapSelectPhotoAction()
    func didTapDeletePhotoAction()
    
    func didTapCreateRoomutton()
}

protocol CreateNewGroupInfoViewPresenterOutput: class {
    func presentActionSheet()
    func showUIImagePickerControllerAsCamera()
    func showUIImagePickerControllerAsLibrary()
}

final class CreateNewGroupInfoViewPresenter: CreateNewGroupInfoViewPresenterProtocol, CreateNewGroupInfoModelOutput {
    weak var view: CreateNewGroupInfoViewPresenterOutput!
    private var model: CreateNewGroupInfoModelProtocol
    
    init(model: CreateNewGroupInfoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapCreateRoomutton() {
        
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
}
