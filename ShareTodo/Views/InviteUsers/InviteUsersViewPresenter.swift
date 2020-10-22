//
//  InviteUsersViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/10/22.
//  Copyright © 2020 jun. All rights reserved.
//

protocol InviteUsersViewPresenterProtocol {
    var view: InviteUsersViewPresenterOutput! { get set }
}

protocol InviteUsersViewPresenterOutput: class {
    
}

final class InviteUsersViewPresenter: InviteUsersViewPresenterProtocol, InviteUsersModelOutput {
    weak var view: InviteUsersViewPresenterOutput!
    private var model: InviteUsersModelProtocol
    
    init(model: InviteUsersModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
