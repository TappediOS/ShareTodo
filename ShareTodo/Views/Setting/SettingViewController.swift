//
//  SettingViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class SettingViewController: UITableViewController {
    private var presenter: SettingViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupNavigationItem()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.me()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupNavigationItem() {
        let stopItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapStopButton))
        self.navigationItem.leftBarButtonItem = stopItem
        self.navigationItem.leftBarButtonItem?.tintColor = .systemGray
        self.navigationItem.title = R.string.localizable.settings()
    }
    
    @objc func tapStopButton() {
        self.presenter.didTapStopButton()
    }
    
    func inject(with presenter: SettingViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension SettingViewController: SettingViewPresenterOutput {
    func dismissSettingVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
