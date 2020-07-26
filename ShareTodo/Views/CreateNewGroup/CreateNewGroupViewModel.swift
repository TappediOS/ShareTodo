//
//  CreateNewGroupViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol CreateNewGroupModelProtocol {
    var presenter: CreateNewGroupModelOutput! { get set }
}

protocol CreateNewGroupModelOutput: class {
    
}

final class CreateNewGroupModel: CreateNewGroupModelProtocol {
    weak var presenter: CreateNewGroupModelOutput!
}

