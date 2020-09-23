//
//  UserDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import FSCalendar

final class UserDetailViewController: UIViewController {
    private var presenter: UserDetailViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupTaskLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupCalenderView()
        self.setupGroupImageView()
        self.setupGroupNameLabel()
        self.setupGroupTaskLabel()
        self.setupActivityIndicator()
    }
    
    func setupNavigationBar() {
        //TODO:- 以下を実際のユーザ名に変更すること
        self.navigationItem.title = "さんま"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func setupCalenderView() {
        self.calenderView.delegate = self
        self.calenderView.dataSource = self
    }
    
    func setupGroupImageView() {
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
    }
    
    func setupGroupNameLabel() {
        self.groupNameLabel.adjustsFontSizeToFitWidth = true
        self.groupNameLabel.minimumScaleFactor = 0.4
    }
    
    func setupGroupTaskLabel() {
        self.groupTaskLabel.adjustsFontSizeToFitWidth = true
        self.groupTaskLabel.minimumScaleFactor = 0.4
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    func inject(with presenter: UserDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension UserDetailViewController: UserDetailViewPresenterOutput {
    
}

extension UserDetailViewController: FSCalendarDelegate, FSCalendarDataSource {
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if arc4random() % 15 == 0 {
            let image = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
            return image
        }
        return nil
    }
}
