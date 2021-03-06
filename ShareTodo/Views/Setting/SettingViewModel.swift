//
//  SettingViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Purchases
import Firebase

protocol SettingModelProtocol {
    var presenter: SettingModelOutput! { get set }
    var numberOfSection: Int { get set }
    
    func chekeTheIndexPath(indexPath: IndexPath)
    func getNumberOfRowsInSection(section: Int) -> Int
    func getTitleforHeaderInSection(section: Int) -> String
}

protocol SettingModelOutput: class {
    func openAccountVC()
    func openSubscriptionStatusVC()
    func openIntroductionShareTodoPlusVC()
    func openPushNotificationVC(url: URL)
    func openAskQuestionVC(url: URL)
    func openFeedbackVC(url: URL)
    func openReviewInAppStore(url: URL)
    func showShareActivityVC(shareText: String?, shareURL: URL)
    func openTermOfUseVC(url: URL)
    func openPrivacyPolicyVC(url: URL)
    
    func startRestore()
    func successRestoreSubscription()
    func error(error: Error)
    func productError()
}

final class SettingModel: SettingModelProtocol {
    weak var presenter: SettingModelOutput!
    
    var numberOfSection = 6
    
    private func checkSection0(indexPath: IndexPath) {
        switch indexPath.item {
        case 0: self.presenter.openAccountVC()
        default: return
        }
    }
    
    private func checkSection1(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.checkingIfAUserSubscribed()
        case 1:
            self.presenter.startRestore()
            self.restoreSubscription()
        default: return
        }
    }
    
    private func checkSection2(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
            self.presenter.openPushNotificationVC(url: url)
        default: return
        }
    }
    
    private func checkSection3(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            // contact us
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let iOSVersion = "\(UIDevice.current.systemName)%20\(UIDevice.current.systemVersion)"
            let userID = Auth.auth().currentUser?.uid ?? ""
            guard let url = URL(string: R.string.localizable.contactUsURL(appVersion, iOSVersion, userID)) else { return }
            self.presenter.openAskQuestionVC(url: url)
        case 1:
            // feedback
            guard let url = URL(string: R.string.localizable.feedbackURL()) else { return }
            self.presenter.openFeedbackVC(url: url)
        case 2:
            // review in app strore 
            guard let url = URL(string: R.string.sharedString.appStoreReviewURL()) else { return }
            self.presenter.openReviewInAppStore(url: url)
        case 3:
            // Share shareTODO
            guard let url = URL(string: R.string.sharedString.shareShareTodoURL()) else { return }
            self.presenter.showShareActivityVC(shareText: nil, shareURL: url)
        default: return
        }
    }
    
    private func checkSection4(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            // term of user
            guard let url = URL(string: R.string.sharedString.shareTodoTermOfUseURL()) else { return }
            self.presenter.openTermOfUseVC(url: url)
        case 1:
            // privacy policy
            guard let url = URL(string: R.string.sharedString.shareTodoPrivacyPolicyURL()) else { return }
            self.presenter.openPrivacyPolicyVC(url: url)
        default: return
        }
    }
    
    func chekeTheIndexPath(indexPath: IndexPath) {
        switch indexPath.section {
        case 0: self.checkSection0(indexPath: indexPath)
        case 1: self.checkSection1(indexPath: indexPath)
        case 2: self.checkSection2(indexPath: indexPath)
        case 3: self.checkSection3(indexPath: indexPath)
        case 4: self.checkSection4(indexPath: indexPath)
        default: return
        }
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 1
        case 3: return 4
        case 4: return 2
        case 5: return 1
        default: return 0
        }
    }
    
    func getTitleforHeaderInSection(section: Int) -> String {
        switch section {
        case 0: return R.string.localizable.general()
        case 1: return R.string.localizable.subscription()
        case 2: return R.string.localizable.settings()
        case 3: return R.string.localizable.support()
        case 4: return R.string.localizable.about()
        case 5: return R.string.localizable.blankString()
        default: return R.string.localizable.blankString()
        }
    }
    
    private func restoreSubscription() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                self.presenter.productError()
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                self.presenter.productError()
                return
            }
            
            if entitlement.isActive == true {
                self.presenter.successRestoreSubscription()
            } else {
                self.presenter.successRestoreSubscription()
            }
        }
    }
    
    private func checkingIfAUserSubscribed() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                return
            }
            
            guard entitlement.isActive == true else {
                self.presenter.openIntroductionShareTodoPlusVC()
                return
            }
            
            
            self.presenter.openSubscriptionStatusVC()
        }
    }
}
