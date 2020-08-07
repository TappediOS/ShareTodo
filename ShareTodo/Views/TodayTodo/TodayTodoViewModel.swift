//
//  TodayTodoViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase

protocol TodayTodoModelProtocol {
    var presenter: TodayTodoModelOutput! { get set }
    var groups: [Group] { get set }
    var todos: [Todo] { get set }
    
    func fetchGroups()
    func fetchTodayTodo(groupDocuments: [QueryDocumentSnapshot], userID: String)
    
    func isFirstOpen() -> Bool
}

protocol TodayTodoModelOutput: class {
    func successFetchTodayTodo()
}

final class TodayTodoModel: TodayTodoModelProtocol {
    weak var presenter: TodayTodoModelOutput!
    var groups: [Group] = Array()
    var todos: [Todo] = Array()
    private var firestore: Firestore!
    private var listener: ListenerRegistration?
    
    init() {
        self.setUpFirestore()
    }
    
    deinit {
        listener?.remove()
    }
    
    func setUpFirestore() {
        self.firestore = Firestore.firestore()
        let settings = FirestoreSettings()
        self.firestore.settings = settings
    }
    
    func fetchGroups() {
        guard let user = Auth.auth().currentUser else { return }
        
        self.listener = self.firestore.collection("todo/v1/groups/").whereField("members", arrayContains: user.uid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = documentSnapshot?.documents else {
                print("The document doesn't exist.")
                return
            }
            
            self?.groups = documents.compactMap { queryDocumentSnapshot -> Group? in
                return try? queryDocumentSnapshot.data(as: Group.self)
            }
            
            self?.fetchTodayTodo(groupDocuments: documents, userID: user.uid)
        }
    }
    
    private func getTodayFormat() -> String {
        let formatter = DateFormatter()
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
                let documentRef = "todo/v1/groups/" + document.documentID + "/todo/" + userID + "_" + todayFormat
                self?.firestore.document(documentRef).getDocument { (document, error) in
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
                        self?.todos.append(todo)
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
    
    func isFirstOpen() -> Bool {
        //TODO:- 実装後に以下の一文を取り除くこと
        return true
        UserDefaults.standard.register(defaults: ["isFirstOpen": true])
        if !UserDefaults.standard.bool(forKey: "isFirstOpen") { return false }
        
        UserDefaults.standard.set(false, forKey: "isFirstOpen")
        return true
    }
}
