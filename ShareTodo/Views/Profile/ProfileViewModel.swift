//
//  ProfileViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol ProfileModelProtocol {
    var presenter: ProfileModelOutput! { get set }
}

protocol ProfileModelOutput: class {
    
}

final class ProfileModel: ProfileModelProtocol {
    weak var presenter: ProfileModelOutput!
}
