//
//  UserDetailViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

protocol UserDetailModelProtocol {
    var presenter: UserDetailModelOutput! { get set }
    var group: Group { get set }
    var user: User { get set }
    
    func calculateForNavigationImage(height: CGFloat) -> (scale: CGFloat, xTranslation: CGFloat, yTranslation: CGFloat)
}

protocol UserDetailModelOutput: class {
    
}

final class UserDetailModel: UserDetailModelProtocol {
    weak var presenter: UserDetailModelOutput!
    var group: Group
    var user: User
    
    init(group: Group, user: User) {
        self.group = group
        self.user = user
    }
    
    
    func calculateForNavigationImage(height: CGFloat) -> (scale: CGFloat, xTranslation: CGFloat, yTranslation: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - NavigationImageConst.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (NavigationImageConst.NavBarHeightLargeState - NavigationImageConst.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = NavigationImageConst.ImageSizeForSmallState / NavigationImageConst.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        let sizeDiff = NavigationImageConst.ImageSizeForLargeState * (1.0 - factor)
        let yTranslation: CGFloat = {
            let maxYTranslation = NavigationImageConst.ImageBottomMarginForLargeState - NavigationImageConst.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (NavigationImageConst.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        return (scale, xTranslation, yTranslation)
    }
}
