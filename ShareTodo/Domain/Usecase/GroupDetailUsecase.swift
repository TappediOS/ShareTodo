//
//  GroupUsecase.swift
//  ShareTodo
//
//  Created by jun on 2020/09/14.
//  Copyright © 2020 jun. All rights reserved.
//


final class GroupDetailUsecase {
    var repository: GroupDetailRepositoryProtocol
    
    init(repository: GroupDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchGroup(groupID: String) {
        self.repository.fetchGroup(groupID: groupID)
    }
    
}
