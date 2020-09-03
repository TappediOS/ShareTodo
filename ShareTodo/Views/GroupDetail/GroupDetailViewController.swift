//
//  GroupDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/02.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    private var presenter: GroupDetailViewPresenterProtocol!
    
    @IBOutlet weak var groupDetailCollectionView: UICollectionView!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupUIBarButtonItem()
        self.setupGroupDetailCollectionView()
        self.setupActivityIndicator()
    }
    
    func setupNavigationBar() {
        //TODO:- group名に変更すること
        self.navigationItem.title = "Group Name"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUIBarButtonItem() {
        let editGroupButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup(_:)))
        
        editGroupButtonItem.tintColor = .systemPink
        self.navigationItem.rightBarButtonItem = editGroupButtonItem
    }
    
    func setupGroupDetailCollectionView() {
        print(view.frame.width, UIScreen.main.bounds.width)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 95)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 40, right: 16)
        
        self.groupDetailCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        self.groupDetailCollectionView.delegate = self
        self.groupDetailCollectionView.dataSource = self
        self.groupDetailCollectionView.register(R.nib.groupDetailCollectionViewCell(), forCellWithReuseIdentifier: "GroupDetailCell")
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    @objc func editGroup(_ sender: UIButton) {
        
    }
    
    func inject(with presenter: GroupDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension GroupDetailViewController: GroupDetailViewPresenterOutput {
    
}

extension GroupDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.groupDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupDetailCell", for: indexPath)
        
        return cell
    }

}
