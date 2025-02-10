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
            return .schedule
        case .grades:
            return .grades
        case .settings:
            return .settings
        }
    }
    
    var title: String {
        switch self {
        case .schedule:
            return .schedule(.title)
        case .grades:
            return .grades(.title)
        case .settings:
            return .settings(.title)
        }
    }

    @ViewBuilder
    func tabItem() -> some View {
        image.imageScale(.large)
        Text(title)
    }

    var label: some View {
        Label {
            Text(title)
        } icon: {
            image
        }
    }
}
