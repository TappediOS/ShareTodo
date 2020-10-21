//
//  MainTabBarViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    private var presenter: MainTabBarViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let todayTodoVC = TodayTodoViewBuilder.create()
        let todayTodoNavigationController = UINavigationController(rootViewController: todayTodoVC)
        
        let groupTodoVC = GroupTodoViewBuilder.create()
        let groupTodoNavigationController = UINavigationController(rootViewController: groupTodoVC)
        
        let profileVC = ProfileViewBuilder.create()
        let profileNavigationController = UINavigationController(rootViewController: profileVC)
        
        let todayTodoItemImage = UIImage(systemName: "checkmark.circle")
        let todayTodoItemSelectedImage = UIImage(systemName: "checkmark.circle.fill")
        
        let groupTodoTabBarItemImage = UIImage(systemName: "person.3")
        let groupTodoTabBarItemSelectedImage = UIImage(systemName: "person.3.fill")
        
        let profileTabBarItemImage = UIImage(systemName: "person")
        let profileTabBarItemSelectedImage = UIImage(systemName: "person.fill")
        
        todayTodoVC.tabBarItem = UITabBarItem(title: R.string.localizable.today(), image: todayTodoItemImage, selectedImage: todayTodoItemSelectedImage)
        groupTodoVC.tabBarItem = UITabBarItem(title: R.string.localizable.group(), image: groupTodoTabBarItemImage, selectedImage: groupTodoTabBarItemSelectedImage)
        profileVC.tabBarItem = UITabBarItem(title: R.string.localizable.me(), image: profileTabBarItemImage, selectedImage: profileTabBarItemSelectedImage)
        
        UITabBar.appearance().tintColor = .systemGreen
        self.viewControllers = [todayTodoNavigationController, groupTodoNavigationController, profileNavigationController]
    }
    
    func inject(with presenter: MainTabBarViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension MainTabBarViewController: MainTabBarViewPresenterOutput {
    
}
