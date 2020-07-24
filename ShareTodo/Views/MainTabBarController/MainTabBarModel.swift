//
//  MainTabBarModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol MainTabBarModelProtocol {
    var presenter: MainTabBarModelOutput! { get set }
}

protocol MainTabBarModelOutput: class {
    
}

final class MainTabBarModel: MainTabBarModelProtocol {
    weak var presenter: MainTabBarModelOutput!
}

