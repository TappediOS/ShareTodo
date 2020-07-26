//
//  CreateNewGroupInfoViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol CreateNewGroupInfoViewPresenterProtocol {
    var view: CreateNewGroupInfoViewPresenterOutput! { get set }
    
    func didTapStopCreateRoomButton()
    func didTapCreateRoomutton()
}

protocol CreateNewGroupInfoViewPresenterOutput: class {
    func dismissCreateChatRoomVC()
}

final class CreateNewGroupInfoViewPresenter: CreateNewGroupInfoViewPresenterProtocol, CreateNewGroupInfoModelOutput {
    weak var view: CreateNewGroupInfoViewPresenterOutput!
    private var model: CreateNewGroupInfoModelProtocol
    
    init(model: CreateNewGroupInfoModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapStopCreateRoomButton() {
        self.view.dismissCreateChatRoomVC()
    }
    
    func didTapCreateRoomutton() {
        
    }
}
