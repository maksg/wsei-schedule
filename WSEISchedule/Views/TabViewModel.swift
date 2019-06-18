//
//  TabViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI

final class TabViewModel: BindableObject {
    let didChange = PassthroughSubject<TabViewModel, Never>()
    
    let scheduleViewModel: ScheduleViewModel = .init()
    let settingsViewModel: SettingsViewModel = .init()
    
    var selectedTab: Tab = .schedule {
        didSet {
            didChange.send(self)
        }
    }
    
}
