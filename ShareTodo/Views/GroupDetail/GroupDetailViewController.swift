//
//  GroupDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    private var presenter: GroupDetailViewPresenterProtocol!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupActivityIndicator()
    }
    
    func setupNavigationBar() {
        //TODO:- group名に変更すること
        self.navigationItem.title = "Group Name"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let editGroupButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup(_:)))
        
        editGroupButtonItem.tintColor = .systemPink
        self.navigationItem.rightBarButtonItem = editGroupButtonItem
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    @objc func editGroup(_ sender: UIButton) {
        
    }
    
    func inject(with presenter: GroupDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupDetailViewController: GroupDetailViewPresenterOutput {
    
}
