//
//  MainTabViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

final class MainTabViewModel: ObservableObject {
    let scheduleViewModel: ScheduleViewModel = .init()
    let settingsViewModel: SettingsViewModel = .init()
    
    @Published var selectedTab: Tab = .schedule
}
