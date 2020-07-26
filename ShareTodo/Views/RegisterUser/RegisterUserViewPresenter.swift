//
//  RegisterUserViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol RegisterUserViewPresenterProtocol {
    var view: RegisterUserViewPresenterOutput! { get set }
}

protocol RegisterUserViewPresenterOutput: class {
    
}

final class RegisterUserViewPresenter: RegisterUserViewPresenterProtocol, RegisterUserModelOutput {
    weak var view: RegisterUserViewPresenterOutput!
    private var model: RegisterUserModelProtocol
    
    init(model: RegisterUserModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}

