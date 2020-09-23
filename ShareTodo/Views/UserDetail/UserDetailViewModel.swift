//
//  UserDetailViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

protocol UserDetailModelProtocol {
    var presenter: UserDetailModelOutput! { get set }
}

protocol UserDetailModelOutput: class {
    
}

final class UserDetailModel: UserDetailModelProtocol {
    weak var presenter: UserDetailModelOutput!
}
