//
//  AccountViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

protocol AccountModelProtocol {
    var presenter: AccountModelOutput! { get set }
}

protocol AccountModelOutput: class {
    
}

final class AccountModel: AccountModelProtocol {
    weak var presenter: AccountModelOutput!
    
}
