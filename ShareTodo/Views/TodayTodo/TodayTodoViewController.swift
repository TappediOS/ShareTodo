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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupNavigationBar()
        self.setupTodayTodoCollectionView()
        
        self.presenter.didViewDidLoad()
    }
    
    func setupView() {
        self.view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Today"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupTodayTodoCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 95)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.todayTodoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.todayTodoCollectionView.backgroundColor = .secondarySystemBackground
        
        self.todayTodoCollectionView.delegate = self
        self.todayTodoCollectionView.dataSource = self
    }
    
    func inject(with presenter: TodayTodoViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension TodayTodoViewController: TodayTodoViewPresenterOutput {
    func reloadTodayTodoCollectionView() {
        DispatchQueue.main.async { self.todayTodoCollectionView.reloadData() }
    }
}

extension TodayTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfTodayTodo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayTodoCollectionViewCellId, for: indexPath) as! TodayTodoCollectionViewCell

        let todo = self.presenter.todayTodos[indexPath.item]
        //TODO:- 実際の文字列を表示すること
        cell.taskLabel.text = todo
        cell.groupImageView.image = UIImage(systemName: "cloud.sun.rain.fill")
        cell.groupImageView.tintColor = .systemTeal
        
        cell.radioButtonAction = { [weak self] in
            self?.presenter.didTapRadioButton(index: indexPath.item)
        }
   
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 0, bottom: 40, right: 0)
    }
}
