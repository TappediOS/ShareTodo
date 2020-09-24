//
//  UserDetailViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol UserDetailModelProtocol {
    var presenter: UserDetailModelOutput! { get set }
    var group: Group { get set }
    var user: User { get set }
    
    func calculateForNavigationImage(height: Double) -> (scale: Double, xTranslation: Double, yTranslation: Double)
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
    
    
    func calculateForNavigationImage(height: Double) -> (scale: Double, xTranslation: Double, yTranslation: Double) {
        let coeff: Double = {
            let delta = height - Double(NavigationImageConst.NavBarHeightSmallState)
            let heightDifferenceBetweenStates = (NavigationImageConst.NavBarHeightLargeState - NavigationImageConst.NavBarHeightSmallState)
            return delta / Double(heightDifferenceBetweenStates)
        }()

        let factor: Double = Double(NavigationImageConst.ImageSizeForSmallState / NavigationImageConst.ImageSizeForLargeState)

        let scale: Double = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(NavigationImageConst.ImageMaxScale, sizeAddendumFactor + factor)
        }()

        let sizeDiff = Double(NavigationImageConst.ImageSizeForLargeState) * (1.0 - factor)
        let yTranslation: Double = {
            let maxYTranslation = Double(NavigationImageConst.ImageBottomMarginForLargeState - NavigationImageConst.ImageBottomMarginForSmallState) + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Double(NavigationImageConst.ImageBottomMarginForSmallState) + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        return (scale, xTranslation, yTranslation)
    }
}
