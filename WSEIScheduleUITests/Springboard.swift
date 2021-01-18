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
            icon.press(forDuration: 1.3)

            let removeAppButton = springboard.buttons["Remove App"]
            if removeAppButton.exists {
                removeAppButton.tap()
            }
            springboard.buttons["Delete App"].tap()
            springboard.buttons["Delete"].tap()
        }
    }
}
