//
//  GroupDetailCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/09/03.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

class GroupDetailCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

}
