//
//  GroupTableViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

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
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

