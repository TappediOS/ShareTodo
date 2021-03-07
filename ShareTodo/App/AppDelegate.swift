//
//  AppDelegate.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import Purchases

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        if #available(iOS 13, *) {
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = Routes.decideRootViewController()
            window?.makeKeyAndVisible()
        }
        
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: R.string.sharedString.revenueCatShareTodoPublicSDKKey())
        Purchases.shared.delegate = self
        
        // ログイン状態が変化するたびに呼び出され，revenueCatにIDを登録する
        Auth.auth().addStateDidChangeListener { (_, user) in
            guard let uid = user?.uid else { return }
            Purchases.shared.identify(uid, { (_, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                print("User \(uid) signed in")
            })
        }
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        ShareTodoRemoteConfig.fetchLeatest()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: Purchases.PurchaserInfo) {
        guard let entitlemant = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
            print("entitlement is nil")
            return
        }
        
        if entitlemant.isActive == true {
            NotificationCenter.default.post(name: .startSubscribedNotification, object: nil)
        } else {
            NotificationCenter.default.post(name: .endSubscribedNotification, object: nil)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // ForeGround
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // response
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let uid = Auth.auth().currentUser?.uid, let fcmToken = fcmToken {
            print("fcmToken: \(fcmToken)")
            self.setFcmToken(userID: uid, fcmToken: fcmToken)
        }
    }
    
    func setFcmToken(userID: String, fcmToken: String) {
        let firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        firestore.settings = settings
        firestore.collection("todo/v1/users/").document(userID).updateData(["fcmToken": fcmToken]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
    }
}
