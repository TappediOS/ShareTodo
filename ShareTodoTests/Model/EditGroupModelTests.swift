//
//  EditGroupModelTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/10/23.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class EditGroupModelTests: XCTestCase {
    
    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {

    }
    
    func test_selectedUserEqualMe() {
        let model = EditGroupModelMock()
        
        for tmp in 0 ..< model.groupUsers.count {
            tmp == 0 ? XCTAssertTrue(model.selectedUserEqualMe(index: tmp)): XCTAssertFalse(model.selectedUserEqualMe(index: tmp))
        }
    }
    
    func test_getSelectedUser() {
        let user1 = User(id: "id1", name: "user1", profileImageURL: "u1")
        let user2 = User(id: "id2", name: "user2", profileImageURL: "u2")
        let user3 = User(id: "id3", name: "user3", profileImageURL: "u3")
        let user4 = User(id: "id4", name: "user4", profileImageURL: "u4")
        let user5 = User(id: "id5", name: "user5", profileImageURL: "u5")
        let user6 = User(id: "id6", name: "user6", profileImageURL: "u6")
        let model = EditGroupModelMock()
        
        for tmp in -10 ... model.groupUsers.count + 10 {
            switch tmp {
            case 0: XCTAssertEqual(model.getSelectedUser(index: tmp), user1)
            case 1: XCTAssertEqual(model.getSelectedUser(index: tmp), user2)
            case 2: XCTAssertEqual(model.getSelectedUser(index: tmp), user3)
            case 3: XCTAssertEqual(model.getSelectedUser(index: tmp), user4)
            case 4: XCTAssertEqual(model.getSelectedUser(index: tmp), user5)
            case 5: XCTAssertEqual(model.getSelectedUser(index: tmp), user6)
            default: XCTAssertNil(model.getSelectedUser(index: tmp))
            }
        }
    }

    func test_setMayRemoveUserUID() {
        let model = EditGroupModelMock()
        model.setMayRemoveUserUID(uid: "newID")
        XCTAssertEqual(model.mayRemoveUserUID, "newID")
    }
    
    func test_resetMayRemoveUserUID() {
        let model = EditGroupModelMock()
        model.setMayRemoveUserUID(uid: "newID")
        XCTAssertEqual(model.mayRemoveUserUID, "newID")
        model.resetMayRemoveUserUID()
        XCTAssertNil(model.mayRemoveUserUID)
        model.resetMayRemoveUserUID()
        XCTAssertNil(model.mayRemoveUserUID)
        model.setMayRemoveUserUID(uid: "newID2")
        model.setMayRemoveUserUID(uid: "newID3")
        XCTAssertEqual(model.mayRemoveUserUID, "newID3")
    }
}
