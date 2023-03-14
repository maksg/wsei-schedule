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
        app.launchArguments.append(ProcessInfo.testsKey)

        #if !targetEnvironment(macCatalyst)
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }
        #endif
    }

    func testMakeScreenshots() {
        app.launch()

        takeScreenshot(named: "SignIn")

        let signInButton = app.buttons["SignInButton"]
        signInButton.tap()
        XCTAssert(signInButton.waitForNonExistence(timeout: 10))

        var progressIndicator = app.activityIndicators.firstMatch
        XCTAssert(progressIndicator.waitForNonExistence(timeout: 10))

        let historyButton = app.buttons["ScheduleHistory"]
        XCTAssert(historyButton.waitForExistence(timeout: 10))

        takeScreenshot(named: "Schedule")

        historyButton.tap()

        sleep(1)

        takeScreenshot(named: "ScheduleHistory")

        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            tabBar.buttons.element(boundBy: 1).tap()

            progressIndicator = app.activityIndicators.firstMatch
            XCTAssert(progressIndicator.waitForNonExistence(timeout: 10))

            takeScreenshot(named: "Grades")

            tabBar.buttons.element(boundBy: 2).tap()
            takeScreenshot(named: "Settings")
        } else {
            let collectionView = app.collectionViews["Sidebar"]
            collectionView.buttons.element(boundBy: 1).tap()

            progressIndicator = app.activityIndicators.firstMatch
            XCTAssert(progressIndicator.waitForNonExistence(timeout: 10))

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
        #if targetEnvironment(macCatalyst)
        let device = "Mac"
        #else
        let device = UIDevice.current.name
        #endif
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(device)-\(name).png",
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

extension XCUIElement {

    /**
     * Waits the specified amount of time for the element’s `exists` property to become `false`.
     *
     * - Parameter timeout: The amount of time to wait.
     * - Returns: `false` if the timeout expires without the element coming out of existence.
     */
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let timeStart = Date().timeIntervalSince1970

        while Date().timeIntervalSince1970 <= (timeStart + timeout) {
            if !exists { return true }
        }

        return false
    }

}
