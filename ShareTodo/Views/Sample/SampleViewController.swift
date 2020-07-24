//
//  SampleViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class SampleViewController: UIViewController {
    private var presenter: SampleViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inject(with presenter: SampleViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension SampleViewController: SampleViewPresenterOutput {
    
}
