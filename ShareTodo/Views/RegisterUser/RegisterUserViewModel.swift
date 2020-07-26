//
//  RegisterUserViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol RegisterUserModelProtocol {
    var presenter: RegisterUserModelOutput! { get set }
}

protocol RegisterUserModelOutput: class {
    
}

final class RegisterUserModel: RegisterUserModelProtocol {
    weak var presenter: RegisterUserModelOutput!
}

