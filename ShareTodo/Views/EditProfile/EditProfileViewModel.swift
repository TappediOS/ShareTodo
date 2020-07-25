//
//  EditProfileViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/25.
//  Copyright © 2020 jun. All rights reserved.
//

protocol EditProfileModelProtocol {
    var presenter: EditProfileModelOutput! { get set }
}

protocol EditProfileModelOutput: class {
    
}

final class EditProfileModel: EditProfileModelProtocol {
    weak var presenter: EditProfileModelOutput!
}
