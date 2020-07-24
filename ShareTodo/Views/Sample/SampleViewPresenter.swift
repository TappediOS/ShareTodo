//
//  SampleViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SampleViewPresenterProtocol {
    var view: SampleViewPresenterOutput! { get set }
}

protocol SampleViewPresenterOutput: class {
    
}

final class SampleViewPresenter: SampleViewPresenterProtocol, SampleModelOutput {
    weak var view: SampleViewPresenterOutput!
    private var model: SampleModelProtocol
    
    init(model: SampleModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
}
