//
//  EditProfileViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol EditProfileViewPresenterProtocol {
    var view: EditProfileViewPresenterOutput! { get set }
    
    func didTapStopEditProfileButton()
    func didTapSaveEditProfileButton()
    func didTapChangeProfileButton()
}

protocol EditProfileViewPresenterOutput: class {
    func dismissEditProfileVC()
    func presentActionSheet()
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
    }
    
    func didTapSaveEditProfileButton() {
        
    }
    
    func didTapChangeProfileButton() {
        self.view.presentActionSheet()
    }
}
