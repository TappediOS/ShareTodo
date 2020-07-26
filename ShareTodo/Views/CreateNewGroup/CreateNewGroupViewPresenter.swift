//
//  CreateNewGroupViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol CreateNewGroupViewPresenterProtocol {
    var view: CreateNewGroupViewPresenterOutput! { get set }
}

protocol CreateNewGroupViewPresenterOutput: class {
    
}

final class CreateNewGroupViewPresenter: CreateNewGroupViewPresenterProtocol, CreateNewGroupModelOutput {
    weak var view: CreateNewGroupViewPresenterOutput!
    private var model: CreateNewGroupModelProtocol
    
    init(model: CreateNewGroupModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
