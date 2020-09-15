//
//  UserDataStore.swift
//  ShareTodo
//
//  Created by jun on 2020/09/15.
//  Copyright © 2020 jun. All rights reserved.
//


protocol UserCompleteDelegate: class {
    func success(user: User)
    func success(users: [User])
    func failuer(error: Error)
}

class UserDataStore {
    static let userDataStore = UserDataStore()
    weak var delegate: UserCompleteDelegate?
    
    var users: [User] = [] {
        didSet {
            guard let lastUser = self.users.last else { return }
            delegate?.success(user: lastUser)
        }
    }
    
    private init() { }
    
    func append(user: User) {
        var users = self.users.filter { $0.id != user.id }
        users.append(user)
        self.users = users
    }
    
    //TODO: - ソートの処理をする
    func sort() {
        
    }
    
    //TODO: - フィルターをかける処理をする
    func fillter() -> [User] {
        var users = self.users
        users.swapAt(0, self.users.count - 1)
        return users
    }
    
    func search(userID: String) -> User? {
        return self.users.filter { $0.id == userID }.first
    }
}
