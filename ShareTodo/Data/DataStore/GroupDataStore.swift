//
//  GroupDataStore.swift
//  ShareTodo
//
//  Created by jun on 2020/09/15.
//  Copyright © 2020 jun. All rights reserved.
//

protocol GroupCompleteDelegate: class {
    func success(group: Group)
    func success(groups: [Group])
    func failure(error: Error)
}

class GroupDataStore {
    static let groupDataStore = GroupDataStore()
    weak var delegate: GroupCompleteDelegate?
    
    var groups: [Group] = [] {
        didSet {
            guard let lastGroup = self.groups.last else { return }
            delegate?.success(group: lastGroup)
        }
    }
    
    private init() { }
    
    func append(group: Group) {
        var groups = self.groups
        groups = groups.filter { $0.groupID != group.groupID }
        groups.append(group)
        self.groups = groups
    }
    
    //TODO: - ソートの処理をする
    func sort() {
        
    }
    
    //TODO: - フィルターをかける処理をする
    func fillter() -> [Group] {
        var groups = self.groups
        groups.swapAt(0, groups.count - 1)
        return groups
    }
    
    func search(groupID: String) -> Group? {
        return self.groups.filter { $0.groupID == groupID }.first
    }
    
}
