//
//  SettingViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SettingViewPresenterProtocol {
    var view: SettingViewPresenterOutput! { get set }
}

protocol SettingViewPresenterOutput: class {
    
}

final class SettingViewPresenter: SettingViewPresenterProtocol, SettingModelOutput {
    weak var view: SettingViewPresenterOutput!
    private var model: SettingModelProtocol
    
    init(model: SettingModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
