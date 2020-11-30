//
//  ProfileViewModelMock.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/25.
//  Copyright © 2020 jun. All rights reserved.
//

@testable import ShareTodo
import Foundation

class ProfileViewModelMock: ProfileModelProtocol {
    var presenter: ProfileModelOutput!
    var isUserSubscribed: Bool = false
    
    func fetchUser() {
        let result = User(id: "123", name: "Rock", profileImageURL: nil)
        self.presenter.successFetchUser(user: result)
    }
    
    func checkingIfAUserSubscribed() {
        self.isUserSubscribed = true
        self.presenter.userSubscribed()
    }
    
    @objc func startSubscribed() {
        self.isUserSubscribed = true
        self.presenter.userStartSubscribed()
    }
    
    @objc func endSubscribed() {
        self.isUserSubscribed = false
        self.presenter.userEndSubscribed()
    }
}
