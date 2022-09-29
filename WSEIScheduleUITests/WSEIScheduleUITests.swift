//
//  WSEIScheduleUITests.swift
//  WSEIScheduleUITests
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import XCTest

class WSEIScheduleUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }
    }

    override func tearDownWithError() throws {
        Springboard.deleteMyApp()
    }

    func testMakeScreenshots() {
        app.launch()

        takeScreenshot(named: "SignIn")

        let loginTextField = app.textFields["LoginTextField"]
        loginTextField.tap()
        loginTextField.typeText("maksymiliangalas")

        let passwordSecureField = app.secureTextFields["PasswordSecureField"]
        passwordSecureField.tap()
        passwordSecureField.typeText("xeztad-zuhwob-9Zedki")

        app.buttons["SignInButton"].tap()

        let firstCell = app.collectionViews["ScheduleList"].cells.element(boundBy: 1)
        XCTAssert(firstCell.waitForExistence(timeout: 20))
        firstCell.tap()

        app.navigationBars.firstMatch.tap()

        takeScreenshot(named: "Schedule")

        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            tabBar.buttons.element(boundBy: 1).tap()
            takeScreenshot(named: "Grades")

            tabBar.buttons.element(boundBy: 2).tap()
            takeScreenshot(named: "Settings")
        } else {
            let collectionView = app.collectionViews.firstMatch
            collectionView.buttons.element(boundBy: 1).tap()
            takeScreenshot(named: "Grades")
        }

        app.buttons["SignOutButton"].tap()
    }

    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil
        )

        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways

        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }

}
