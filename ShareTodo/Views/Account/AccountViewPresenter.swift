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
    
    func didViewDidLoad()
    func didTapTableViewCell(indexPath: IndexPath)
}

protocol AccountViewPresenterOutput: class {
    func setUserName(name: String)
    func setUserID(uid: String)
    func setNotificationLabel(status: String)
    func tableViewReloadData()
    func showErrorAleartView(error: Error)
}

final class AccountViewPresenter: AccountViewPresenterProtocol, AccountModelOutput {
    weak var view: AccountViewPresenterOutput!
    private var model: AccountModelProtocol
        
    init(model: AccountModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didViewDidLoad() {
        self.model.fetchUserData()
    }
    
    func didTapTableViewCell(indexPath: IndexPath) {
        self.model.chekeTheIndexPath(indexPath: indexPath)
    }

    func successFetchUser(user: User) {
        self.view.setUserName(name: user.name)
        self.view.setUserID(uid: user.id ?? "")
        if (user.fcmToken != nil) {
            self.view.setNotificationLabel(status: R.string.localizable.yes())
        } else {
            self.view.setNotificationLabel(status: R.string.localizable.no())
        }
        self.view.tableViewReloadData()
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
    }
}
