//
//  SettingViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SettingModelProtocol {
    var presenter: SettingModelOutput! { get set }
    var numberOfSection: Int { get set }
    
    func getNumberOfRowsInSection(section: Int) -> Int
    func getTitleforHeaderInSection(section: Int) -> String
}

protocol SettingModelOutput: class {
    
}

final class SettingModel: SettingModelProtocol {
    weak var presenter: SettingModelOutput!
    
    var numberOfSection = 6
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 1
        case 3: return 4
        case 4: return 2
        case 5: return 1
        default: return 0
        }
    }
    
    func getTitleforHeaderInSection(section: Int) -> String {
        switch section {
        case 0: return "1"
        case 1: return "2"
        case 2: return "1"
        case 3: return "4"
        case 4: return "2"
        case 5: return "1"
        default: return "0"
        }
    }
}
