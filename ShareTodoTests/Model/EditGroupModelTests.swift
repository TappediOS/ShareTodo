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
        
        for tmp in 0 ... 5 {
            tmp == 0 ? XCTAssertTrue(model.selectedUserEqualMe(index: tmp)): XCTAssertFalse(model.selectedUserEqualMe(index: tmp))
        }
    }
    
    func test_getSelectedUser() {
        
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
