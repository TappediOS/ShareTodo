//
//  GroupDetailCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/09/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke

class GroupDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCell()
        self.setupRadioButton()
        self.setupProfileImageView()
        self.setupNameLabel()
        self.setupMessageLabel()
    }
    
    private func setupCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    private func setupRadioButton() {
        self.radioImageView.layer.cornerRadius = self.radioImageView.frame.width / 2
        self.radioImageView.layer.masksToBounds = true
        self.radioImageView.tintColor = .systemGreen
    }
    
    private func setupProfileImageView() {
        self.profileImageView.layer.borderWidth = 0.25
        self.profileImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func setupNameLabel() {
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.minimumScaleFactor = 0.4
    }
    
    private func setupMessageLabel() {
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageLabel.minimumScaleFactor = 0.4
        self.messageLabel.isHidden = true
    }
    
    func isFinishedUser(user: User, isFinishedUsersIDs: [String]) -> Bool {
        guard let userId = user.id else { return false }
        return isFinishedUsersIDs.contains(userId)
    }
    
    func configure(with user: User, isFinishedUsersIDs: [String], messageDictionary: [String: String]) {
        let isFinished = isFinishedUser(user: user, isFinishedUsersIDs: isFinishedUsersIDs)
        let radioButtonImage = isFinished ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        
        self.nameLabel.text = user.name
        self.radioImageView.image = radioButtonImage
        
        if let userId = user.id, let message = messageDictionary[userId] {
            self.messageLabel.text = R.string.localizable.message_colon() + message
            self.messageLabel.isHidden = false
            self.messageLabel.sizeToFit()
        } else {
            self.messageLabel.isHidden = true
        }
        
        guard let url = URL(string: user.profileImageURL ?? "") else { return }
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.defaultProfileImage())
            loadImage(with: url, options: options, into: self.profileImageView, progress: nil, completion: nil)
        }
    }
    
}
