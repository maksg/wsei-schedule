//
//  Tab.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case schedule
    case grades
    case settings

    var image: Image {
        switch self {
        case .schedule:
            return Image.schedule
        case .grades:
            return Image.grades
        case .settings:
            return Image.settings
        }
    }
    
    var title: String {
        switch self {
        case .schedule:
            return Translation.Schedule.title.localized
        case .grades:
            return Translation.Grades.title.localized
        case .settings:
            return Translation.Settings.title.localized
        }
    }

    @ViewBuilder
    func tabItem() -> some View {
        image.imageScale(.large)
        Text(title)
    }
}
