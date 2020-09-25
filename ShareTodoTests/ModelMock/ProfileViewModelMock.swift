//
//  ProfileViewModelMock.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

@testable import ShareTodo
import Firebase

class ProfileViewModelMock: ProfileModelProtocol {
    var presenter: ProfileModelOutput!
    
    func fetchUser() {
        let result = User(id: "123", name: "Rock", profileImageURL: nil)
        self.presenter.successFetchUser(user: result)
    }
}

