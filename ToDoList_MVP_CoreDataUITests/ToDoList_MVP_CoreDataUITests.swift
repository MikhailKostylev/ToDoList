//
//  ToDoList_MVP_CoreDataUITests.swift
//  ToDoList_MVP_CoreDataUITests
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import XCTest

class ToDoListMVPCoreDataUITests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        
    }

    func testTitleExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        let title = app.staticTexts["To Do List"]
        XCTAssertTrue(title.exists)
    }
    
    func testAddAlertExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["To Do List"].buttons["Add"].tap()
        XCTAssertTrue(app.alerts.element.exists)
        
        app.alerts["New Task"].scrollViews.otherElements.buttons["Cancel"].tap()
        XCTAssertFalse(app.alerts.element.exists)
    }
    
    func testAddAlertAppendItem() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["To Do List"].buttons["Add"].tap()
        
        let elementsQuery = app.alerts["New Task"].scrollViews.otherElements
        elementsQuery.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText("Foo")
        
        app.alerts["New Task"].scrollViews.otherElements.buttons["Enter"].tap()
        
        let tablesQuery = app.tables
        let fooStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Foo"]/*[[".cells.staticTexts[\"Foo\"]",".staticTexts[\"Foo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(fooStaticText.exists)
    }
    
    func testDeleteItem() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Foo"]/*[[".cells.staticTexts[\"Foo\"]",".staticTexts[\"Foo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.sheets.scrollViews.otherElements.buttons["Delete"].tap()
        
        let emptyListTable = XCUIApplication().tables["Empty list"]
        emptyListTable.swipeDown()
        
        let tablesQuery = app.tables
        let fooStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Foo"]/*[[".cells.staticTexts[\"Foo\"]",".staticTexts[\"Foo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertFalse(fooStaticText.exists)
    }
}
