//
//  GroupDetailViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupDetailViewPresenterProtocol {
    var view: GroupDetailViewPresenterOutput! { get set }
}

protocol GroupDetailViewPresenterOutput: class {
    
}

final class GroupDetailViewPresenter: GroupDetailViewPresenterProtocol, GroupDetailModelOutput {
    weak var view: GroupDetailViewPresenterOutput!
    private var model: GroupDetailModelProtocol
    
    init(model: GroupDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
