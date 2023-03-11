//
//  Bundle+AppVersion.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension Bundle {

    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

}
