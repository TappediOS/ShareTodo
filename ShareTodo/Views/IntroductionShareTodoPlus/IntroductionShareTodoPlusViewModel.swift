//
//  IntroductionShareTodoPlusViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Purchases

protocol IntroductionShareTodoPlusModelProtocol {
    var presenter: IntroductionShareTodoPlusModelOutput! { get set }
    
    func fetchAvailableProducts()
    func makeMonthSubscriptionPurchase()
    func makeAnnualSubscriptioinPurhase()
}

protocol IntroductionShareTodoPlusModelOutput: class {
    func successFetchMonthSubscriptionPrise(price: String)
    func successFetchAnnualSubscriptionPrise(price: String)
    
    func successPurchaseMonthSubscription()
    func successPurchaseAnnualSubscription()
    
    func successRestoreMonthSubscription()
    func successRestoreAnnualSubscription()
}

final class IntroductionShareTodoPlusModel: IntroductionShareTodoPlusModelProtocol {
    weak var presenter: IntroductionShareTodoPlusModelOutput!
    
    private var monthAvailablePackage: Purchases.Package?
    private var annualAvailablePackage: Purchases.Package?
    
    func fetchAvailableProducts() {
        Purchases.shared.offerings { (offerings, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let offerings = offerings else {
                print("offerings = nil")
                return
            }
            
            guard let offer = offerings.current else {
                print("offer = nil")
                return
            }
            
            let packages = offer.availablePackages
            
            for i in 0 ..< packages.count {
                let package = packages[i]
                let product = packages[i].product
                let title = product.localizedTitle
                let prise = product.localizedPrice
                
                var duration = ""
                
                guard let subsctiptionPeriod = product.subscriptionPeriod else {
                    print("subsctiptionPeriod = nil")
                    return
                }
                
                switch subsctiptionPeriod.unit {
                case .month:
                    guard let prise = prise else { continue }
                    self.monthAvailablePackage = package
                    self.presenter.successFetchMonthSubscriptionPrise(price: prise)
                    duration = "month"
                case .year:
                    guard let prise = prise else { continue }
                    self.annualAvailablePackage = package
                    self.presenter.successFetchAnnualSubscriptionPrise(price: prise)
                    duration = "year"
                default:
                    print("duration error")
                }
                
                print("---- subscription Infomation ----")
                print(" package  = ", package)
                print(" product  = ", product)
                print(" title    = ", title)
                print(" prise    = ", prise ?? "")
                print(" duration = ", duration)
                print("++++ subscription Infomation ++++")
            }
        }
    }
    
    func makeMonthSubscriptionPurchase() {
        guard let package = self.monthAvailablePackage else { return }
        
        Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                return
            }
            
            if purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()]?.isActive == true {
                self.presenter.successPurchaseMonthSubscription()
            }
        }
    }
    
    func makeAnnualSubscriptioinPurhase() {
        guard let package = self.annualAvailablePackage else { return }
        
        Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                return
            }
            
            if purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()]?.isActive == true {
                self.presenter.successPurchaseMonthSubscription()
            }
        }
    }
}
