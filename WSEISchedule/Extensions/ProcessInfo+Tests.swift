//
//  ProcessInfo+Tests.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 14/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension ProcessInfo {
    static let testsKey: String = "tests"

    var isTesting: Bool {
        arguments.contains(ProcessInfo.testsKey)
    }
}
