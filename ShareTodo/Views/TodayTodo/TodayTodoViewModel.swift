//
//  TodayTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase
import FirebaseMessaging
import Purchases

protocol TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput! { get set }
    var groups: [Group] { get set }
    var todos: [Todo] { get set }
    var isUserSubscribed: Bool { get set }
    
    func fetchGroups()
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String)
    
    func isFirstOpen() -> Bool
    func isFinishedTodo(index: Int) -> Bool
    func isWrittenMessage(index: Int) -> Bool
    
    func unfinishedTodo(index: Int)
    func finishedTodo(index: Int)
    
    func writeMessage(message: String, index: Int)
    func cancelMessage(index: Int)
    
    func setFcmToken()
    
    func checkingIfAUserSubscribed()
}

protocol TodayTodoModelOutput: class {
    func successFetchTodayTodo()
    func successUnfinishedTodo()
    func successFinishedTodo()
    func successWriteMessage()
    func successCancelMessage()
    
    func userSubscribed()
    func userStartSubscribed()
    func userEndSubscribed()
    
    func error(error: Error)
}

final class TodayTodoModel: TodayTodoModelProtocol {
    weak var presenter: TodayTodoModelOutput!
    var groups: [Group] = Array()
    var todos: [Todo] = Array()
    var isUserSubscribed: Bool = false
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    init() {
        self.setUpFirestore()
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
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startSubscribed), name: .startSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endSubscribed), name: .endSubscribedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func fetchGroups() {
        guard let user = Auth.auth().currentUser else { return }
        
        self.listener = self.firestore.collection("todo/v1/groups/").whereField("members", arrayContains: user.uid).addSnapshotListener { [weak self] (documentSnapshot, error) in
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
            
            self.groups = documents.compactMap { queryDocumentSnapshot -> Group? in
                return try? queryDocumentSnapshot.data(as: Group.self)
            }
            
            self.todos.removeAll()
            self.fetchTodayTodo(groupDocuments: documents, userID: user.uid)
        }
    }
    
    func getTodayFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy_MM_dd"
        return formatter.string(from: Date())
    }
    
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let todayFormat = getTodayFormat()
        
        for document in groupDocuments {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) { [weak self] in
                guard let self = self else { return }
                
                let documentRef = "todo/v1/groups/" + document.documentID + "/todo/" + userID + "_" + todayFormat
                print(documentRef)
                self.firestore.document(documentRef).getDocument { (document, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let document = document, document.exists else {
                        print("The document doesn't exist.")
                        dispatchGroup.leave()
                        return
                    }
                    
                    do {
                        let todoData = try document.data(as: Todo.self)
                        guard let todo = todoData else { return }
                        self.todos.append(todo)
                    } catch {
                        print("Error happen.")
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.presenter.successFetchTodayTodo()
        }
    }
    
    func isContainsTodoInGroups(index: Int) -> Bool {
        let group = groups[index]
        return !self.todos.filter({ $0.groupID == group.groupID ?? ""}).isEmpty
    }
    
    func isFinishedTodo(index: Int) -> Bool {
        guard isContainsTodoInGroups(index: index) else { return false }
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        
        if let todo = todo {
            return todo.isFinished
        } else {
            return false
        }
    }
    
    func isWrittenMessage(index: Int) -> Bool {
        guard isContainsTodoInGroups(index: index) else { return false }
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        
        if let todo = todo, let message = todo.message, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        return false
    }
    
    func getFinishedTodoIndex(groupIndex: Int) -> Int? {
        for tmp in 0 ..< todos.count {
            if self.todos[tmp].groupID == self.groups[groupIndex].groupID ?? "" { return tmp }
        }
        return nil
    }
    
    func unfinishedTodo(index: Int) {
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        guard var finishedTodo = todo else { return }
        guard let finishedTodoIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        
        finishedTodo.isFinished = false
        finishedTodo.message = String()
        let todayFormat = getTodayFormat()
        
        let documentRef = "todo/v1/groups/" + finishedTodo.groupID + "/todo/" + finishedTodo.userID + "_" + todayFormat
        
        do {
            _ = try self.firestore.document(documentRef).setData(from: finishedTodo, merge: true) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.presenter.error(error: error)
                    return
                }
                
                self.todos[finishedTodoIndex].isFinished = false
                self.todos[finishedTodoIndex].message = nil
                self.presenter.successUnfinishedTodo()
                Analytics.logEvent(R.string.sharedString.unFinishedTodo_EventName(), parameters: nil)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
            self.presenter.error(error: error)
            return
        }
    }
    
    func finishedTodo(index: Int) {
        guard let user = Auth.auth().currentUser else { return }
        guard let groupID = self.groups[index].groupID else { return }
        let todayFormat = getTodayFormat()
        let documentRef = "todo/v1/groups/" + groupID + "/todo/" + user.uid + "_" + todayFormat
        let todo = Todo(isFinished: true, userID: user.uid, groupID: groupID)
        
        do {
            _ = try self.firestore.document(documentRef).setData(from: todo, merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.presenter.error(error: error)
                    return
                }
                
                self.presenter.successFinishedTodo()
                Analytics.logEvent(R.string.sharedString.finishedTodo_EventName(), parameters: nil)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
            self.presenter.error(error: error)
            return
        }
    }
    
    func writeMessage(message: String, index: Int) {
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        guard var finishedTodo = todo else { return }
        guard let finishedTodoIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        
        finishedTodo.message = message
        let todayFormat = getTodayFormat()
        
        let documentRef = "todo/v1/groups/" + finishedTodo.groupID + "/todo/" + finishedTodo.userID + "_" + todayFormat
        
        do {
            _ = try self.firestore.document(documentRef).setData(from: finishedTodo, merge: true) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.presenter.error(error: error)
                    return
                }
                
                self.todos[finishedTodoIndex].message = message
                self.presenter.successWriteMessage()
                Analytics.logEvent(R.string.sharedString.writeMessage_EventName(), parameters: [R.string.sharedString.writeMessage_EventParam(): message])
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
    
    func cancelMessage(index: Int) {
        let todo = todos.filter({ $0.groupID == groups[index].groupID ?? ""}).first
        guard var finishedTodo = todo else { return }
        guard let finishedTodoIndex = getFinishedTodoIndex(groupIndex: index) else { return }
        
        finishedTodo.message = String()
        let todayFormat = getTodayFormat()
        
        let documentRef = "todo/v1/groups/" + finishedTodo.groupID + "/todo/" + finishedTodo.userID + "_" + todayFormat
        
        do {
            _ = try self.firestore.document(documentRef).setData(from: finishedTodo, merge: true) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.presenter.error(error: error)
                    return
                }
                
                self.todos[finishedTodoIndex].message = nil
                self.presenter.successCancelMessage()
                Analytics.logEvent(R.string.sharedString.cancelWriteMessage_EventName(), parameters: nil)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
    
    func setFcmToken() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        firestore.collection("todo/v1/users/").document(userID).updateData(["fcmToken": fcmToken]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func checkingIfAUserSubscribed() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
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
                return
            }
            
            guard entitlement.isActive == true else {
                self.isUserSubscribed = false
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
        self.isUserSubscribed = false
        self.presenter.userEndSubscribed()
    }
    
    @objc func viewWillEnterForeground() {
        self.fetchGroups()
    }
    
    func isFirstOpen() -> Bool {
        //TODO:- 実装後に以下の一文を取り除くこと
        return true
        UserDefaults.standard.register(defaults: ["isFirstOpen": true])
        if !UserDefaults.standard.bool(forKey: "isFirstOpen") { return false }
        
        UserDefaults.standard.set(false, forKey: "isFirstOpen")
        return true
    }
}
