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
        
        self.setupGroupTableView()
    }
    
    func setupGroupTableView() {
        self.groupTableView.rowHeight = 85
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.tableFooterView = UIView()
    }
    
    func inject(with presenter: GroupTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupTodoViewController: GroupTodoViewPresenterOutput {
    
}

extension GroupTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.groupTableView.dequeueReusableCell(withIdentifier: self.groupTodoCellID, for: indexPath)
                         as? GroupTableViewCell else { return UITableViewCell() }
        
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
