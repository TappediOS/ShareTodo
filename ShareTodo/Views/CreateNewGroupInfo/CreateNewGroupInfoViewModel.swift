//
//  CreateNewGroupInfoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol CreateNewGroupInfoModelProtocol {
    var presenter: CreateNewGroupInfoModelOutput! { get set }
}

protocol CreateNewGroupInfoModelOutput: class {
    
}

final class CreateNewGroupInfoModel: CreateNewGroupInfoModelProtocol {
    weak var presenter: CreateNewGroupInfoModelOutput!
}
