//
//  UserDetailViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase
import Purchases

protocol UserDetailModelProtocol {
    var presenter: UserDetailModelOutput! { get set }
    var group: Group { get set }
    var user: User { get set }
    var todos: [Todo] { get set }
    var isUserSubscribed: Bool { get set }
    
    func fetchTodoList()
    func isTheDayAWeekAgo(date: Date) -> Bool
    func getContaintFinishedDate(date: Date) -> Bool
    func calculateForNavigationImage(height: Double) -> (scale: Double, xTranslation: Double, yTranslation: Double)

    func getMinimumDate() -> Date
    
    func checkingIfAUserSubscribed()
}

protocol UserDetailModelOutput: class {
    func successFetchTodoList()
    
    func userSubscribed()
    func userDontSubscribed()
    
    func userStartSubscribed()
    func userEndSubscribed()
    
    func error(error: Error)
}

final class UserDetailModel: UserDetailModelProtocol {
    weak var presenter: UserDetailModelOutput!
    var group: Group
    var user: User
    var todos: [Todo] = Array()
    var isUserSubscribed: Bool = false
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    let dateFormatter = DateFormatter()
    
    
    init(group: Group, user: User) {
        self.group = group
        self.user = user
        self.setUpFirestore()
        self.setupDataFormatter()
        self.setupNotificationCenter()
    }
    
    deinit {
        listener?.remove()
    }
    
    func setUpFirestore() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    func setupDataFormatter() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startSubscribed), name: .startSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endSubscribed), name: .endSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func fetchTodoList() {
        guard let userID = self.user.id else { return }
        guard let groupID = self.group.groupID else { return }
        let collectionRef = "todo/v1/groups/" + groupID + "/todo"
        self.listener = self.firestore.collection(collectionRef).whereField("userID", isEqualTo: userID) .addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            guard let documents = documentSnapshot?.documents else {
                print("The document doesn't exist.")
                return
            }
            
            self.todos = documents.compactMap { queryDocumentSnapshot -> Todo? in
                return try? queryDocumentSnapshot.data(as: Todo.self)
            }
            
            self.presenter.successFetchTodoList()
        }
    }
    
    func isTheDayAWeekAgo(date: Date) -> Bool {
        let aWeekAgo = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
        let tomorrow = Date(timeIntervalSinceNow: 60 * 60 * 24)
        return aWeekAgo < date && date < tomorrow
    }
    
    func getTodoListAsFinishedDate() -> [String] {
        return self.todos.filter { $0.isFinished }.reduce([String]()) { list, todo in
            var list = list
            guard todo.isFinished else { return list }
            guard let createdAt = todo.createdAt?.dateValue() else { return list }
            list.append(dateFormatter.string(from: createdAt))
            return list
        }
    }
    
    func getContaintFinishedDate(date: Date) -> Bool {
        let list = getTodoListAsFinishedDate()
        return list.contains(self.dateFormatter.string(from: date))
    }
    
    //swiftlint:disable:next large_tuple
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
    
    func getMinimumDate() -> Date {
        guard let groupCreatedDate = self.group.createdAt?.dateValue() else {
            // `groupCreatedDate`が`nil`ならば，Todosの中から一番古い日を取得する
            let list: [Date] = self.todos.filter { $0.isFinished }.reduce([Date]()) { list, todo in
                var list = list
                guard todo.isFinished else { return list }
                guard let createdAt = todo.createdAt?.dateValue() else { return list }
                list.append(createdAt)
                return list
            }.sorted()
            
            guard let first = list.first else { return Date(timeIntervalSinceNow: -60 * 60 * 24 * 30) }
            return first
        }
        
        return groupCreatedDate
    }
    
    func checkingIfAUserSubscribed() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.presenter.error(error: error)
                return
            }
            
            guard let purchaserInfo = purchaserInfo else {
                print("purchaserInfo = nil")
                self.isUserSubscribed = false
                return
            }
            
            guard let entitlement = purchaserInfo.entitlements[R.string.sharedString.revenueCatShareTodoEntitlementsID()] else {
                print("entitlement = nil")
                self.isUserSubscribed = false
                self.presenter.userDontSubscribed()
                return
            }
            
            guard entitlement.isActive == true else {
                self.isUserSubscribed = false
                self.presenter.userDontSubscribed()
                return
            }
            
            self.isUserSubscribed = true
            // subscがtrueの時のみpresenterに通知し，calendarのreload処理を行う
            self.presenter.userSubscribed()
        }
    }
    
    @objc func startSubscribed() {
        self.presenter.userStartSubscribed()
    }
    
    @objc func endSubscribed() {
        self.presenter.userEndSubscribed()
    }
    
    @objc func viewWillEnterForeground() {
        self.fetchTodoList()
    }
}
