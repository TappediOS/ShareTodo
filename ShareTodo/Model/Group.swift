//
//  Group.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import Firebase

struct Group: Codable {
    @DocumentID var groupID: String?
    let name: String
    let task: String
    let members: [String]
    let profileImageURL: String?
    let createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}
