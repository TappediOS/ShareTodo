//
//  AccountViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/06.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol AccountModelProtocol {
    var presenter: AccountModelOutput! { get set }
    
    func chekeTheIndexPath(indexPath: IndexPath)
}

protocol AccountModelOutput: class {
    
}

final class AccountModel: AccountModelProtocol {
    weak var presenter: AccountModelOutput!
    
    func chekeTheIndexPath(indexPath: IndexPath) {
        guard indexPath.section == 1, indexPath.item == 0 else { return }
        print("dlete")
    }
}
