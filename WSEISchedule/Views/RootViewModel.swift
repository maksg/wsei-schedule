//
//  RootViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

final class RootViewModel: ObservableObject {

    // MARK: Properties

    let webView: ScheduleWebView
    let scheduleViewModel: ScheduleViewModel
    let settingsViewModel: SettingsViewModel
    
    @Published var selectedTab: Tab = .schedule
    
    var student: Student {
        UserDefaults.standard.student
    }
    
    @Published var isSignedIn: Bool = false

    // MARK: Initialization
    
    init() {
        webView = ScheduleWebView()
        scheduleViewModel = ScheduleViewModel(webView: webView)
        settingsViewModel = SettingsViewModel(webView: webView)
        isSignedIn = !student.login.isEmpty
    }

    // MARK: Methods
    
    func reloadLectures() {
        withAnimation {
            isSignedIn = !student.login.isEmpty
        }
        guard isSignedIn else { return }

        webView.login = student.login
        webView.password = student.password
        webView.reload()
    }
}
