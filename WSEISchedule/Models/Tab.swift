//
//  Tab.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

enum Tab: Int, CaseIterable {
    case schedule
    case settings
    
    var title: String {
        switch self {
        case .schedule:
            return Translation.Schedule.title.localized
        case .settings:
            return Translation.Settings.title.localized
        }
    }
}
