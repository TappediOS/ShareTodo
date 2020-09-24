//
//  GroupTodoViewModelTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/08/31.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class GroupTodoViewModelTests: XCTestCase {
    let user1 = User(id: "id1", name: "user1", profileImageURL: "u1")
    let user2 = User(id: "id2", name: "user2", profileImageURL: "u2")
    let user3 = User(id: "id3", name: "user3", profileImageURL: "u3")
    let user4 = User(id: "id4", name: "user4", profileImageURL: "u4")
    let user5 = User(id: "id5", name: "user5", profileImageURL: "u5")
    let user6 = User(id: "id6", name: "user6", profileImageURL: "u6")
    let group1 = Group(groupID: "1", name: "g1", task: "lock", members: ["id1", "id2"], profileImageURL: "p1")
    let group2 = Group(groupID: "2", name: "g2", task: "test", members: ["id1", "id2"], profileImageURL: "p1")
    let group3 = Group(groupID: "3", name: "g3", task: "been", members: ["id1", "id3"], profileImageURL: "p2")
    let group4 = Group(groupID: "4", name: "g4", task: "ring", members: ["id2", "id3"], profileImageURL: "p2")
    let group5 = Group(groupID: "5", name: "g5", task: "long", members: ["id4", "id5"], profileImageURL: "p3")
    let group6 = Group(groupID: "6", name: "g6", task: "yous", members: ["id1", "id2", "id3"], profileImageURL: "p3")
    let group7 = Group(groupID: "7", name: "g7", task: "meet", members: ["id3", "id4", "id5"], profileImageURL: "p3")
    let group8 = Group(groupID: "8", name: "g8", task: "iRis", members: ["id2", "id4", "id5", "id6"], profileImageURL: "p3")
    
    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {

    }
    
    func testSortGroupUsersArray() {
        var groups = [group1, group3]
        var exp = [[user1, user2], [user1, user3]]
        var users = [[user1, user3], [user1, user2]]
        users = GroupTodoModel().sortGroupUsersArray(groupArray: groups, groupUsersArray: users)
        XCTAssertEqual(users, exp)
        
        groups = [group1, group4, group5]
        exp = [[user1, user2], [user2, user3], [user4, user5]]
        users = [[user4, user5], [user1, user2], [user2, user3]]
        users = GroupTodoModel().sortGroupUsersArray(groupArray: groups, groupUsersArray: users)
        XCTAssertEqual(users, exp)
        
        groups = [group2, group5, group6, group8]
        exp = [[user1, user2], [user4, user5], [user1, user2, user3], [user2, user4, user5, user6]]
        users = [[user1, user2, user3], [user1, user2], [user2, user4, user5, user6], [user4, user5]]
        users = GroupTodoModel().sortGroupUsersArray(groupArray: groups, groupUsersArray: users)
        XCTAssertEqual(users, exp)
        
        groups = [group7]
        exp = [[user3, user4, user5]]
        users = [[user3, user4, user5]]
        users = GroupTodoModel().sortGroupUsersArray(groupArray: groups, groupUsersArray: users)
        XCTAssertEqual(users, exp)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension GroupTodoViewModelTests {
    
}
