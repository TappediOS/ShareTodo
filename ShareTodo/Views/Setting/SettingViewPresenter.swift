//
//  SettingViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SettingViewPresenterProtocol {
    var view: SettingViewPresenterOutput! { get set }
    var numberOfSection: Int { get }
    
    func didTapStopButton()
    func getNumberOfRowsInSection(section: Int) -> Int
    func getTitleforHeaderInSection(section: Int) -> String
}

protocol SettingViewPresenterOutput: class {
    func dismissSettingVC()
}

final class SettingViewPresenter: SettingViewPresenterProtocol, SettingModelOutput {
    weak var view: SettingViewPresenterOutput!
    private var model: SettingModelProtocol
    
    var numberOfSection: Int { return self.model.numberOfSection }
    
    init(model: SettingModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapStopButton() {
        self.view.dismissSettingVC()
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        self.model.getNumberOfRowsInSection(section: section)
    }
    
    func getTitleforHeaderInSection(section: Int) -> String {
        self.model.getTitleforHeaderInSection(section: section)
    }
}
