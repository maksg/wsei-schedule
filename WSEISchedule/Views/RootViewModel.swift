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

    let apiRequest = APIRequest()
    let captchaReader = CaptchaReader()
    let htmlReader = HTMLReader()

    let signInViewModel: SignInViewModel
    let scheduleViewModel: ScheduleViewModel
    let settingsViewModel: SettingsViewModel
    
    @Published var selectedTab: Tab = .schedule
    
    var student: Student {
        UserDefaults.standard.student
    }
    
    @Published var isSignedIn: Bool = false

    // MARK: Initialization
    
    init() {
        signInViewModel = SignInViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        scheduleViewModel = ScheduleViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        settingsViewModel = SettingsViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        isSignedIn = !student.login.isEmpty

        signInViewModel.finishSignIn = { [weak self] in
            self?.reloadLectures()
        }
    }

    // MARK: Methods
    
    func reloadLectures() {
        withAnimation {
            isSignedIn = !student.login.isEmpty
        }
        guard isSignedIn else { return }

        
    }
}
