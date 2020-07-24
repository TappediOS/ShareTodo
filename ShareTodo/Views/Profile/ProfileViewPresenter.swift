//
//  ProfileViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewPresenterOutput! { get set }
}

protocol ProfileViewPresenterOutput: class {
    
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol, ProfileModelOutput {
    weak var view: ProfileViewPresenterOutput!
    private var model: ProfileModelProtocol
    
    init(model: ProfileModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
