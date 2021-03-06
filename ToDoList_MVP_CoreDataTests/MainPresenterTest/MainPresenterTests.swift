//
//  MainPresenterTests.swift
//  ToDoList_MVP_CoreDataTests
//
//  Created by Mikhail Kostylev on 29.05.2022.
//

import XCTest
@testable import ToDoList_MVP_CoreData

class MockView: MainViewProtocol {
    
    func presentAlert(alert: UIAlertController) {}
    
    func refreshTable() {}
}

class MockStoreManager: StoreManagerProtocol {
    
    var items: [MainItem]?
    
    init() {}
    
    convenience init(items: [MainItem]?) {
        self.init()
        self.items = items
    }
    
    func getAllItems() {}
    
    func createItem(name: String) {}
    
    func deleteItem(item: MainItem) {}
    
    func updateItem(item: MainItem, newName: String) {}
}

class MainPresenterTests: XCTestCase {
    
    var view: MockView!
    var presenter: MainPresenterProtocol!
    var storeManager: StoreManagerProtocol!
    var router: RouterProtocol!
    var items = [MainItem]()

    override func setUpWithError() throws {
        let navController = UINavigationController()
        let assembly = Assembly()
        router = Router(navigationController: navController, assembly: assembly)
    }

    override func tearDownWithError() throws {
        view = nil
        storeManager = nil
        presenter = nil
        router = nil
    }

    func testSuccessfullyGetTasks() throws {
        let item = MainItem()
        items.append(item)
        
        view = MockView()
        storeManager = MockStoreManager(items: items)
        presenter = MainPresenter(view: view, storeManager: storeManager, router: router)
        
        var catchItems: [MainItem]?
        catchItems = presenter.items
        
        XCTAssertNotEqual(catchItems?.count, 0)
        XCTAssertEqual(catchItems?.count, 1)
        XCTAssertEqual(catchItems?.count, items.count)
    }
}
