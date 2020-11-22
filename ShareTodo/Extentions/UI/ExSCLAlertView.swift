//
//  ExSCLAlertView.swift
//  ShareTodo
//
//  Created by jun on 2020/11/22.
//  Copyright © 2020 jun. All rights reserved.
//

import SCLAlertView
import UIKit

public extension SCLAlertView {
    func getErrorAlert() -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: view.bounds.width * 0.68, kButtonHeight: 40,
            kTitleFont: UIFont(name: "HiraMaruProN-W4", size: 15) ?? UIFont(),
            kTextFont: UIFont(name: "HiraMaruProN-W4", size: 12) ?? UIFont(),
            kButtonFont: UIFont(name: "HiraMaruProN-W4", size: 12) ?? UIFont(),
            
            showCircularIcon: false, contentViewCornerRadius: 15, fieldCornerRadius: 18, buttonCornerRadius: 18
        )
        
        return SCLAlertView(appearance: appearance)
    }
}
