//
//  IntroductionShareTodoPlusViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class IntroductionShareTodoPlusViewController: UIViewController {
    private var presenter: IntroductionShareTodoPlusViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupView()
        self.setupScrollView()
        self.setupNavigationBar()
    }
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupScrollView() {
        self.scrollView.alwaysBounceVertical = true
    }
    
    func setupNavigationBar() {
        //TODO:- ローカライズ
        self.navigationItem.title = "ShareTodo Plus"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func inject(with presenter: IntroductionShareTodoPlusViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension IntroductionShareTodoPlusViewController: IntroductionShareTodoPlusViewPresenterOutput {
    
}
