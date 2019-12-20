//
//  MainTabViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

final class MainTabViewModel: ObservableObject {
    let webView: ScheduleWebView
    let scheduleViewModel: ScheduleViewModel
    let settingsViewModel: SettingsViewModel
    
    @Published var selectedTab: Tab = .schedule
    
    init() {
        webView = ScheduleWebView()
        scheduleViewModel = ScheduleViewModel(webView: webView)
        settingsViewModel = SettingsViewModel(webView: webView)
    }
}
