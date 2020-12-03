//
//  SettingViewPresenter.swift
//  ShareTodo
//
//  Created by jun on 2020/11/25.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation

protocol SettingViewPresenterProtocol {
    var view: SettingViewPresenterOutput! { get set }
    var numberOfSection: Int { get }
    
    func didTapStopButton()
    func didTapTableViewCell(indexPath: IndexPath)
    func getNumberOfRowsInSection(section: Int) -> Int
    func getTitleforHeaderInSection(section: Int) -> String
}

protocol SettingViewPresenterOutput: class {
    func startActivityIndicator()
    func stopActivityIndicator()
    
    func endIgnoringInteractionEvents()
    func beginIgnoringInteractionEvents()
    
    func dismissSettingVC()
    
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
    
    func showRestoreAleartView()
    func showErrorAleartView(error: Error)
}

final class SettingViewPresenter: SettingViewPresenterProtocol, SettingModelOutput {
    weak var view: SettingViewPresenterOutput!
    private var model: SettingModelProtocol
    
    var numberOfSection: Int { return self.model.numberOfSection }
    
    init(model: SettingModelProtocol) {
        self.model = model
        self.model.presenter = self
    }
    
    func didTapStopButton() {
        self.view.dismissSettingVC()
    }
    
    func didTapTableViewCell(indexPath: IndexPath) {
        self.model.chekeTheIndexPath(indexPath: indexPath)
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        self.model.getNumberOfRowsInSection(section: section)
    }
    
    func getTitleforHeaderInSection(section: Int) -> String {
        self.model.getTitleforHeaderInSection(section: section)
    }
    
    
    func openAccountVC() {
        self.view.openAccountVC()
    }
    
    func openSubscriptionStatusVC() {
        self.view.openSubscriptionStatusVC()
    }
    
    func openIntroductionShareTodoPlusVC() {
        self.view.openIntroductionShareTodoPlusVC()
    }
    
    func openPushNotificationVC(url: URL) {
        self.view.openPushNotificationVC(url: url)
    }
    
    func openAskQuestionVC(url: URL) {
        self.view.openAskQuestionVC(url: url)
    }
    
    func openFeedbackVC(url: URL) {
        self.view.openFeedbackVC(url: url)
    }
    
    func openReviewInAppStore(url: URL) {
        self.view.openReviewInAppStore(url: url)
    }
    
    func showShareActivityVC(shareText: String?, shareURL: URL) {
        self.view.showShareActivityVC(shareText: shareText, shareURL: shareURL)
    }
    
    func openTermOfUseVC(url: URL) {
        self.view.openTermOfUseVC(url: url)
    }
    
    func openPrivacyPolicyVC(url: URL) {
        self.view.openPrivacyPolicyVC(url: url)
    }
    
    func startRestore() {
        self.view.startActivityIndicator()
        self.view.beginIgnoringInteractionEvents()
    }
    
    func successRestoreSubscription() {
        self.view.stopActivityIndicator()
        self.view.showRestoreAleartView()
        self.view.endIgnoringInteractionEvents()
    }
    
    func error(error: Error) {
        self.view.showErrorAleartView(error: error)
        self.view.stopActivityIndicator()
        self.view.endIgnoringInteractionEvents()
    }
    
    func productError() {
        self.view.stopActivityIndicator()
        self.view.endIgnoringInteractionEvents()
    }
}
