//
//  AccountViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol AccountViewPresenterProtocol {
    var view: AccountViewPresenterOutput! { get set }
    
    func didTapTableViewCell(indexPath: IndexPath)
}

protocol AccountViewPresenterOutput: class {
    
}

final class AccountViewPresenter: AccountViewPresenterProtocol, AccountModelOutput {
    weak var view: AccountViewPresenterOutput!
    private var model: AccountModelProtocol
        
    init(model: AccountModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapTableViewCell(indexPath: IndexPath) {
        self.model.chekeTheIndexPath(indexPath: indexPath)
    }

}
