//
//  RootViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

final class RootViewModel: ObservableObject {

    // MARK: - Properties

    let apiRequest = APIRequest()
    let captchaReader = CaptchaReader()
    let htmlReader = HTMLReader()

    let signInViewModel: SignInViewModel
    let scheduleViewModel: ScheduleViewModel
    let gradesViewModel: GradesViewModel
    let settingsViewModel: SettingsViewModel

    @Published var selectedTab: Tab = .schedule {
        didSet {
            guard selectedTab != selectedListItem else { return }
            switch selectedTab {
            case .settings:
                selectedListItem = .schedule
            default:
                selectedListItem = selectedTab
            }
        }
    }

    @Published var selectedListItem: Tab? = .schedule {
        didSet {
            guard selectedTab != selectedListItem && selectedTab != .settings else { return }
            selectedTab = selectedListItem ?? .schedule
        }
    }
    
    var cookies: [HTTPCookie] {
        UserDefaults.standard.cookies
    }
    
    @Published var isSignedIn: Bool = false

    // MARK: - Initialization
    
    init() {
        signInViewModel = SignInViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        scheduleViewModel = ScheduleViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        gradesViewModel = GradesViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)
        settingsViewModel = SettingsViewModel(apiRequest: apiRequest, captchaReader: captchaReader, htmlReader: htmlReader)

        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        isSignedIn = !cookies.isEmpty

        signInViewModel.finishSignIn = { [weak self] in
            self?.checkSignInStatus()
        }
    }

    // MARK: - Methods
    
    func checkSignInStatus() {
        withAnimation {
            isSignedIn = !cookies.isEmpty
        }
    }
}
