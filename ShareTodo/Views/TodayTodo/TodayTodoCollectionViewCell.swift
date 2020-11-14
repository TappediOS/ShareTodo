//
//  TodayTodoCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke

class TodayTodoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var writeMessageButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var radioButtonAction: (() -> Void)?
    var writeMessageButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.setupGroupImageView()
        self.setupTaskLabel()
        self.setupRadioButton()
        self.setupWriteMessageButton()
    }
    
    func setupGroupImageView() {
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
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
        self.radioButton.tintColor = .systemGreen
    }
    
    func setupWriteMessageButton() {
        self.writeMessageButton.layer.masksToBounds = true
        self.writeMessageButton.tintColor = .systemGreen
        self.writeMessageButton.isHidden = true
    }
    
    func configure(with group: Group, isFinished: Bool, isWrittenMessage: Bool) {
        let radioButtonImage = isFinished ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        let writeMessageButtonImage = isWrittenMessage ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        self.taskLabel.text = group.task
        self.groupNameLabel.text = R.string.localizable.group_Colon() + group.name
        self.radioButton.setImage(radioButtonImage, for: .normal)
        
        self.writeMessageButton.isHidden = !isFinished
        self.writeMessageButton.setImage(writeMessageButtonImage, for: .normal)
        
        guard let url = URL(string: group.profileImageURL ?? "") else { return }
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.groupDefaultImage())
            loadImage(with: url, options: options, into: self.groupImageView, progress: nil, completion: nil)
        }
    }
    
    @IBAction func tapRadioButton(_ sender: Any) {
        self.radioButtonAction?()
    }
    
    @IBAction func tapWriteMessageButton(_ sender: Any) {
        self.writeMessageButtonAction?()
    }
}
