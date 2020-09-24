//
//  UserDetailViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

protocol UserDetailViewPresenterProtocol {
    var view: UserDetailViewPresenterOutput! { get set }
    var group: Group { get }
    var user: User { get }
    
    func didScrollViewDidScroll(height: CGFloat)
}

protocol UserDetailViewPresenterOutput: class {
    func moveAndResizeImage(scale: CGFloat, xTranslation: CGFloat, yTranslation: CGFloat)
}

final class UserDetailViewPresenter: UserDetailViewPresenterProtocol, UserDetailModelOutput {
    weak var view: UserDetailViewPresenterOutput!
    private var model: UserDetailModelProtocol
    
    var group: Group { return self.model.group }
    var user: User { return self.model.user }
    
    init(model: UserDetailModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didScrollViewDidScroll(height: CGFloat) {
        let result = self.model.calculateForNavigationImage(height: height)
        self.view.moveAndResizeImage(scale: result.scale, xTranslation: result.xTranslation, yTranslation: result.yTranslation)
    }
}
