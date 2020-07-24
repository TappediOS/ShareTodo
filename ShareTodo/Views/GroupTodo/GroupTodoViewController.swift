//
//  GroupTodoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class GroupTodoViewController: UIViewController {
    private var presenter: GroupTodoViewPresenterProtocol!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var todo = ["test", "test2"]
    private let groupTodoCellID = "GroupTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupGroupTableView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Group"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let makeGroupButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                  style: .plain, target: self, action: #selector(makeGroup(_:)))
       
        makeGroupButtonItem.tintColor = .systemPink
        self.navigationItem.rightBarButtonItem = makeGroupButtonItem
    }
    
    func setupGroupTableView() {
        self.groupTableView.rowHeight = 85
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.tableFooterView = UIView()
    }
    
    /// plusボタン押されたときの処理gropuを作成する
    /// - Parameter sender: button
    @objc func makeGroup(_ sender: UIButton) {
        print("Make Group")
    }
    
    func inject(with presenter: GroupTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupTodoViewController: GroupTodoViewPresenterOutput {
    
}

extension GroupTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.groupTableView.dequeueReusableCell(withIdentifier: self.groupTodoCellID, for: indexPath)
                         as? GroupTableViewCell else { return UITableViewCell() }
        
        //TODO:- 実際の文字列を表示すること
        cell.groupNameLabel.text = "Test"
        cell.groupMembersNameLabel.text = "list, bent, run, aws"
        cell.groupImageView.image = UIImage(systemName: "paperclip.circle.fill")
        cell.groupImageView.tintColor = .systemGreen
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupTableView.deselectRow(at: indexPath, animated: true)
    }
}
