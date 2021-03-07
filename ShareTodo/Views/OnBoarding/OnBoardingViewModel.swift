//
//  OnBoardingViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/15.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase
import AppTrackingTransparency
import AdSupport

protocol OnBoardingModelProtocol {
    var presenter: OnBoardingModelOutput! { get set }

    func requestAdsTrackingIfNeeded()
}

protocol OnBoardingModelOutput: class {
    
}

final class OnBoardingModel: OnBoardingModelProtocol {
    weak var presenter: OnBoardingModelOutput!


    func requestAdsTrackingIfNeeded() {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized: Analytics.logEvent(R.string.sharedString.adsTrackingAuthorized_EventName(), parameters: nil)
                    case .denied: Analytics.logEvent(R.string.sharedString.adsTrackingDenied_EventName(), parameters: nil)
                    case .restricted, .notDetermined: return
                    @unknown default: return
                    }
                })
            }
        } else {
            return
        }
    }
}
