//
//  Springboard.swift
//  WSEIScheduleUITests
//
//  Created by Maksymilian Galas on 18/01/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import XCTest

class Springboard {

    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    /**
     Terminate and delete the app via springboard
     */
    class func deleteMyApp() {
        XCUIApplication().terminate()

        // Force delete the app from the springboard
        let icon = springboard.otherElements["Home screen icons"].icons["WSEI Schedule"]
        if icon.exists {
            icon.press(forDuration: 1)

            let removeAppButton = springboard.buttons["Remove App"]
            if removeAppButton.waitForExistence(timeout: 5) {
                removeAppButton.tap()
            } else {
                XCTFail("Button \"Remove App\" not found")
            }

            let deleteAppButton = springboard.alerts.buttons["Delete App"]
            if deleteAppButton.waitForExistence(timeout: 5) {
                deleteAppButton.tap()
            }
            else {
                XCTFail("Button \"Delete App\" not found")
            }

            let deleteButton = springboard.alerts.buttons["Delete"]
            if deleteButton.waitForExistence(timeout: 5) {
                deleteButton.tap()
            }
            else {
                XCTFail("Button \"Delete\" not found")
            }
        }
    }
}
