//
//  RouterTest.swift
//  ToDoList_MVP_CoreDataTests
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import XCTest
@testable import ToDoList_MVP_CoreData

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let assembly = Assembly()

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assembly: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testExample() throws {
        let item = MainItem()
        router.showDetailVC(with: item)
        let detailVC = navigationController.presentedVC
        
        XCTAssertTrue(detailVC is DetailViewController)
    }
}
