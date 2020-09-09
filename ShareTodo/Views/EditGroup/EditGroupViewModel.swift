//
//  EditGroupViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/09.
//  Copyright © 2020 jun. All rights reserved.
//

protocol EditGroupModelProtocol {
    var presenter: EditGroupModelOutput! { get set }
}

protocol EditGroupModelOutput: class {
    
}

final class EditGroupModel: EditGroupModelProtocol {
    weak var presenter: EditGroupModelOutput!
}

