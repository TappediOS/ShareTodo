//
//  GroupDetailCollectionReusableView.swift
//  ShareTodo
//
//  Created by jun on 2020/09/04.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

class GroupDetailCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //FIXME:- 以下の関数から表示できる様にしたら消すこと
        self.sectionTitleLabel.text = "Today's progress"
    }
    
    func setLabelTitle(title: String) {
        self.sectionTitleLabel.text = title
    }
}
