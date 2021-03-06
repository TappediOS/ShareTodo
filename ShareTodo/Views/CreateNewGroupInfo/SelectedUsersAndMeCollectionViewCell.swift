//
//  SelectedUsersAndMeCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke

class SelectedUsersAndMeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var tapSelectedUsersAndMeCellAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupProfileImageView()
        self.setupUserNameLabel()
    }
    
    private func setupProfileImageView() {
        self.profileImageView.layer.borderWidth = 0.25
        self.profileImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.isUserInteractionEnabled = true
        
        let tapProfileImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapProfileImageView(_:)))
        
        tapProfileImageViewGesture.delegate = self
        self.profileImageView.addGestureRecognizer(tapProfileImageViewGesture)
    }
    
    private func setupUserNameLabel() {
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.minimumScaleFactor = 0.4
    }
    
    func configure(with user: User) {
        self.nameLabel.text = user.name
        
        DispatchQueue.main.async {
            guard let url = URL(string: user.profileImageURL ?? "") else {
                self.profileImageView.image = R.image.defaultProfileImage()
                return
            }
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.defaultProfileImage())
            loadImage(with: url, options: options, into: self.profileImageView, progress: nil, completion: nil)
        }
    }
}

extension SelectedUsersAndMeCollectionViewCell: UIGestureRecognizerDelegate {
    @objc func tapProfileImageView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        // actionが設定されていなければ`return`
        guard let action = tapSelectedUsersAndMeCellAction?() else { return }
        action
    }
}
