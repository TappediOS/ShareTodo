//
//  MainTabBarViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class MainTabBarViewController: UITabBarController {
    private var presenter: MainTabBarViewPresenterProtocol!
    
    private let shareTodoTabBarBannerView = GADBannerView()
    private let BANNER_VIEW_TEST_ID = R.string.sharedString.banner_VIEW_TEST_ID()
    private let BANNER_VIEW_ID = R.string.sharedString.banner_VIEW_ID()
    private var BANNER_VIEW_HIGHT: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter.didViewDidAppear()
    }
    
    func initBannerView() {
        print("\n\n--------INFO ADMOB--------------\n")
        print("Google Mobile ads SDK Versioin -> " + GADMobileAds.sharedInstance().sdkVersion + "\n")
        #if DEBUG
        self.shareTodoTabBarBannerView.adUnitID = BANNER_VIEW_TEST_ID
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["9747b2df917295aa9c8c5a0325953f4e"]
        print("バナー広告：テスト環境\n\n")
        #else
        self.shareTodoTabBarBannerView.adUnitID = BANNER_VIEW_ID
        print("バナー広告：本番環境")
        #endif
        
        self.shareTodoTabBarBannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(shareTodoTabBarBannerView)
        self.view.bringSubviewToFront(shareTodoTabBarBannerView)
        
        self.shareTodoTabBarBannerView.rootViewController = self
        self.shareTodoTabBarBannerView.delegate = self
        
        let frame = { () -> CGRect in
           return view.frame.inset( by: view.safeAreaInsets)
        }()
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)
        self.BANNER_VIEW_HIGHT = adSize.size.height
        self.shareTodoTabBarBannerView.adSize = adSize
        self.shareTodoTabBarBannerView.load(GADRequest())
        self.setupBannarViewAnchor()
    }
    
    func setupBannarViewAnchor() {
        shareTodoTabBarBannerView.heightAnchor.constraint(equalToConstant: self.BANNER_VIEW_HIGHT).isActive = true
        shareTodoTabBarBannerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        shareTodoTabBarBannerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        shareTodoTabBarBannerView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let todayTodoVC = TodayTodoViewBuilder.create()
        let todayTodoNavigationController = UINavigationController(rootViewController: todayTodoVC)
        
        let groupTodoVC = GroupTodoViewBuilder.create()
        let groupTodoNavigationController = UINavigationController(rootViewController: groupTodoVC)
        
        let profileVC = ProfileViewBuilder.create()
        let profileNavigationController = UINavigationController(rootViewController: profileVC)
        
        let todayTodoItemImage = UIImage(systemName: "checkmark.circle")
        let todayTodoItemSelectedImage = UIImage(systemName: "checkmark.circle.fill")
        
        let groupTodoTabBarItemImage = UIImage(systemName: "person.3")
        let groupTodoTabBarItemSelectedImage = UIImage(systemName: "person.3.fill")
        
        let profileTabBarItemImage = UIImage(systemName: "person")
        let profileTabBarItemSelectedImage = UIImage(systemName: "person.fill")
        
        todayTodoVC.tabBarItem = UITabBarItem(title: R.string.localizable.today(), image: todayTodoItemImage, selectedImage: todayTodoItemSelectedImage)
        groupTodoVC.tabBarItem = UITabBarItem(title: R.string.localizable.group(), image: groupTodoTabBarItemImage, selectedImage: groupTodoTabBarItemSelectedImage)
        profileVC.tabBarItem = UITabBarItem(title: R.string.localizable.me(), image: profileTabBarItemImage, selectedImage: profileTabBarItemSelectedImage)
        
        UITabBar.appearance().tintColor = .systemGreen
        self.viewControllers = [todayTodoNavigationController, groupTodoNavigationController, profileNavigationController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.presenter.didTapTabBarItem()
    }
    
    func inject(with presenter: MainTabBarViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension MainTabBarViewController: MainTabBarViewPresenterOutput {
    func initBannerAds() {
        self.initBannerView()
    }
    
    func showBannerAds() {
        
    }
    
    func dismissBannerAds() {
        DispatchQueue.main.async {
            self.shareTodoTabBarBannerView.removeFromSuperview()
        }
    }
    
    func impactFeedbackOccurred() {
        TapticFeedbacker.impact(style: .soft)
    }
    
    func noticeFeedbackOccurredError() {
        TapticFeedbacker.notice(type: .error)
    }
    
    func noticeFeedbackOccurredSuccess() {
        TapticFeedbacker.notice(type: .success)
    }
}

extension MainTabBarViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       print("広告(banner)のロードが完了しました。")
       self.shareTodoTabBarBannerView.alpha = 0
       UIView.animate(withDuration: 1, animations: {
          self.shareTodoTabBarBannerView.alpha = 1
       })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
       print("広告(banner)のロードに失敗しました。: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
       print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
       print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
       print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
       print("adViewWillLeaveApplication")
    }
}
