//
//  ToDoList_MVP_CoreDataUITestsLaunchTests.swift
//  ToDoList_MVP_CoreDataUITests
//
//  Created by Mikhail Kostylev on 27.05.2022.
//

import XCTest

class ToDoListMVPCoreDataUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
