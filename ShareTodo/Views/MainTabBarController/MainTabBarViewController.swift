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
        
        //TODO:- 画像を用意すること
        if #available(iOS 13.0, *) {
            let todayTodoItemImage = UIImage(systemName: "house")
            let todayTodoItemSelectedImage = UIImage(systemName: "house.fill")
            
            let groupTodoTabBarItemImage = UIImage(systemName: "checkmark.circle")
            let groupTodoTabBarItemSelectedImage = UIImage(systemName: "checkmark.circle.fill")
            
            let profileTabBarItemImage = UIImage(systemName: "person.circle")
            let profileTabBarItemSelectedImage = UIImage(systemName: "person.circle.fill")
            
            todayTodoVC.tabBarItem = UITabBarItem(title: nil, image: todayTodoItemImage, selectedImage: todayTodoItemSelectedImage)
            groupTodoVC.tabBarItem = UITabBarItem(title: nil, image: groupTodoTabBarItemImage, selectedImage: groupTodoTabBarItemSelectedImage)
            profileVC.tabBarItem = UITabBarItem(title: nil, image: profileTabBarItemImage, selectedImage: profileTabBarItemSelectedImage)
        } else {
            // Fallback on earlier versions
        }
        
        self.viewControllers = [todayTodoNavigationController, groupTodoNavigationController, profileNavigationController]
    }
    
    func inject(with presenter: MainTabBarViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension MainTabBarViewController: MainTabBarViewPresenterOutput {
    
}
