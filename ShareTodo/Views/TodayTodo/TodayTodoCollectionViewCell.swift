//
//  TodayTodoCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

class TodayTodoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBackground
        
        self.setupGroupImageView()
        self.setupTaskLabel()
        self.setupRadioButton()
    }
    
    func setupGroupImageView() {
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
    }
    
    func setupTaskLabel() {
        self.taskLabel.adjustsFontSizeToFitWidth = true
        self.taskLabel.minimumScaleFactor = 0.4
    }
    
    func setupRadioButton() {
        self.radioButton.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.radioButton.layer.masksToBounds = true
    }
}
