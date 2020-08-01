//
//  GroupTableViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke

class GroupTableViewCell: UITableViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupMembersNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupGroupImageView()
        self.setupGroupNameLabel()
        self.setupGroupMembersNameLabel()
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
    
    func setupGroupMembersNameLabel() {
        self.groupMembersNameLabel.adjustsFontSizeToFitWidth = true
        self.groupMembersNameLabel.minimumScaleFactor = 0.4
    }
    
    func configure(with group: Group) {
        self.groupNameLabel.text = group.name
        groupMembersNameLabel.text = group.members.joined(separator: ", ")
        
        guard let url = URL(string: group.profileImageURL ?? "") else { return }
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: UIImage(named: "placeholderImage"), transition: .fadeIn(duration: 0.25), failureImage: UIImage(named: "defaultProfileImage"))
            loadImage(with: url, options: options, into: self.groupImageView, progress: nil, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
