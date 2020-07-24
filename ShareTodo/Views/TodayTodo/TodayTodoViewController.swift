//
//  TodayTodoViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class TodayTodoViewController: UIViewController {
    private var presenter: TodayTodoViewPresenterProtocol!
    @IBOutlet weak var todayTodoCollectionView: UICollectionView!
    
    private let todayTodoCollectionViewCellId = "TodayTodoCollectionViewCell"
    
    var todo = ["test", "lost", "cooked"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTodayTodoCollectionView()
    }
    
    func setupTodayTodoCollectionView() {
        self.todayTodoCollectionView.collectionViewLayout.invalidateLayout()
        self.todayTodoCollectionView.delegate = self
        self.todayTodoCollectionView.dataSource = self
    }
    
    func inject(with presenter: TodayTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension TodayTodoViewController: TodayTodoViewPresenterOutput {
    
}

extension TodayTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayTodoCollectionViewCellId, for: indexPath) as! TodayTodoCollectionViewCell

        //TODO:- 実際の文字列を表示すること
        cell.taskLabel.text = "朝起きをすること"
        cell.groupImageView.image = UIImage(systemName: "cloud.sun.rain.fill")
        cell.groupImageView.tintColor = .systemTeal
   
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}
