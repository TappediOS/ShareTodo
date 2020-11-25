//
//  SettingViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SettingModelProtocol {
    var presenter: SettingModelOutput! { get set }
}

protocol SettingModelOutput: class {
    
}

final class SettingModel: SettingModelProtocol {
    weak var presenter: SettingModelOutput!
}

