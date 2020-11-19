//
//  UserDetailViewTests.swift
//  ShareTodoTests
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

import XCTest
@testable import ShareTodo

class UserDetailViewTests: XCTestCase {
    var view: UserDetailViewController!
    
    private let xmarkImage = UIImage(systemName: "xmark.seal.fill")?.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
    private let checkmarkImage = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
    private let lockImage = UIImage(systemName: "lock.fill")?.withTintColor(.systemOrange).withRenderingMode(.alwaysOriginal)
    
    override func setUpWithError() throws {
        view = R.storyboard.userDetail().instantiateInitialViewController() as? UserDetailViewController
        guard view != nil else { return }
    }
    
    override func tearDownWithError() throws {
        view = nil
    }
    
    func test_表示時に変数の値が正しいこと() {
        let expectation = self.expectation(description: "expectation")
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        DispatchQueue.main.async {
            XCTAssertEqual(self.view.groupNameLabel.text, "Apple")
            XCTAssertEqual(self.view.groupTaskLabel.text, "Pie")
            XCTAssertNil(self.view.groupImageView.image)
            XCTAssertNil(self.view.profileImageView.image)
            XCTAssertNotNil(self.view.profileImageView)
            XCTAssertEqual(self.view.navigationItem.title, "Joe")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_calenderの表示最大日が今日であること() {
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        XCTAssertEqual(dateFormatter.string(from: self.view.calenderView.maximumDate), dateFormatter.string(from: Date()))
    }
    
    func test_calendarの表示最小値はgroupCreatedAtであること() {
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        XCTAssertNotNil(presenter.group.createdAt?.dateValue())
        XCTAssertEqual(dateFormatter.string(from: self.view.calenderView.minimumDate), dateFormatter.string(from: (presenter.group.createdAt?.dateValue())!))
    }
    
    func test_viewを閉じたときにprofileImageViewがnavigationBarから削除されていること() {
        let expectation = self.expectation(description: "expectation")
        let parentVC = UIViewController()
        let parentViewController = UINavigationController(rootViewController: parentVC)
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        window?.rootViewController = parentViewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            parentVC.navigationController?.pushViewController(self.view, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                //表示されたときはcontaintsされている
                XCTAssertTrue(((self.view.navigationController?.navigationBar.subviews.contains(self.view.profileImageView)) != nil))
                XCTAssertTrue(((parentVC.navigationController?.navigationBar.subviews.contains(self.view.profileImageView)) != nil))
                XCTAssertEqual(self.view.profileImageView.alpha, 1)
                self.view.navigationController?.popViewController(animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    //dismiss後は存在していない
                    XCTAssertFalse((parentVC.navigationController?.navigationBar.subviews.contains(self.view.profileImageView))!)
                    XCTAssertEqual(self.view.profileImageView.alpha, 0)
                    expectation.fulfill()
                })
            })
        })
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    // NOTE:- グループ作成日は15日前である。
    
    func test_サブスク登録しているときのcalenderに表示されてる画像が正しいこと() {
        let presenter = UserDetailViewPresenter(model: UserDetailModelMock())
        view.inject(with: presenter)
        view.loadViewIfNeeded()
        view.view.layoutIfNeeded()
        
        for tmp in -10 ... 15 + 10 {
            let cellDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * Double(tmp))
            let cell = view.calenderView.cell(for: cellDate, at: .current)
            
            self.view.calenderView.setCurrentPage(cellDate, animated: false)
            view.loadViewIfNeeded()
            view.view.layoutIfNeeded()
            
            if tmp >= -10 && tmp < 0 {
                XCTAssertNil(cell?.imageView.image)
                XCTAssertNil(cell?.image)
                continue
            }
            
            if tmp > 15 {
                XCTAssertNil(cell?.imageView.image)
                XCTAssertNil(cell?.image)
                continue
            }
            
            if tmp == 2 || tmp == 4 || tmp == 5 || tmp == 7 || tmp == 9 || tmp == 10 || tmp ==  11 {
                XCTAssertEqual(cell?.imageView.image, self.checkmarkImage, "tmp = \(tmp)")
                XCTAssertEqual(cell?.image, self.checkmarkImage)
                continue
            }
            
            if tmp >= 0 && tmp <= 15 {
                XCTAssertEqual(cell?.imageView.image, self.xmarkImage, "tmp = \(tmp)")
                XCTAssertEqual(cell?.image, self.xmarkImage)
                continue
            }
       
            XCTAssertNil(cell?.imageView.image, "tmp = \(tmp)")
            XCTAssertNil(cell?.image)
        }
    }
}
