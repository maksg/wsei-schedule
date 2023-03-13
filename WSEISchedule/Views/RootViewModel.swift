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

    let apiRequest: APIRequestable
    let htmlReader: HTMLReader = HTMLReader()

    let signInViewModel: SignInViewModel
    let scheduleViewModel: ScheduleViewModel
    let gradesViewModel: GradesViewModel
    let settingsViewModel: SettingsViewModel

    @Published var selectedTab: Tab = .schedule {
        didSet {
            if selectedTab == oldValue {
                scrollToTop = ()
            }

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

    @Published var scrollToTop: Void = ()
    
    var cookies: [HTTPCookie] {
        UserDefaults.standard.cookies
    }
    
    @Published var isSignedIn: Bool = false

    // MARK: - Initialization
    
    init() {
        #if MOCK
        apiRequest = APIRequestMock()
        #elseif DEV
        apiRequest = APIRequest(debug: true)
        #else
        apiRequest = APIRequest()
        #endif

        signInViewModel = SignInViewModel()
        scheduleViewModel = ScheduleViewModel(apiRequest: apiRequest, htmlReader: htmlReader)
        gradesViewModel = GradesViewModel(apiRequest: apiRequest, htmlReader: htmlReader)
        settingsViewModel = SettingsViewModel(apiRequest: apiRequest, htmlReader: htmlReader)

        // TODO: Remove once everyone migrates
        Keychain.clean()

        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        isSignedIn = !cookies.isEmpty

        signInViewModel.finishSignIn = { [weak self] in
            self?.checkSignInStatus()
            self?.reloadData()
        }
    }

    // MARK: - Methods

    func reloadData() {
        guard isSignedIn else { return }

        Task {
            await scheduleViewModel.reload()
        }
        Task {
            await gradesViewModel.fetchGradeSemesters()
        }
        Task {
            await settingsViewModel.loadStudentInfo()
        }
    }
    
    private func checkSignInStatus() {
        withAnimation {
            isSignedIn = !cookies.isEmpty
        }
    }
}
