//
//  ProfileViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewPresenterOutput! { get set }
    
    func didTapEditProfileButton()
    func didViewDidLoad()
}

protocol ProfileViewPresenterOutput: class {
    func presentEditProfileVC()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol, ProfileModelOutput {
    weak var view: ProfileViewPresenterOutput!
    private var model: ProfileModelProtocol
    
    init(model: ProfileModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapEditProfileButton() {
        self.view.presentEditProfileVC()
    }
    
    func didViewDidLoad() {
        self.model.fetchUser()
    }
    
    func successFetchUser(user: User) {
        
    }
}
