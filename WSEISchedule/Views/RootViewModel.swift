//
//  RootViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

final class RootViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    let apiRequest: APIRequestable
    let htmlReader: HTMLReader = HTMLReader()

    let signInViewModel: SignInViewModel
    let scheduleViewModel: ScheduleViewModel
    let gradesViewModel: GradesViewModel
    let settingsViewModel: SettingsViewModel

    private let authSession: WebAuthenticationSession
    private var isCheckingSignInStatus: Bool = false

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
    
    override init() {
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

        let url = URL(string: "https://dziekanat.wsei.edu.pl/Konto/LogowanieStudenta")!
        authSession = WebAuthenticationSession(url: url)

        super.init()

        authSession.onSuccess = { [weak self] cookies in self?.onSignIn(cookies: cookies) }
        authSession.onFailure = { [weak self] error in self?.onError(error, tab: nil) }
        authSession.presentationContextProvider = self

        // TODO: Remove once everyone migrates
        Keychain.clean()
        UserDefaults.standard.removeObject(forKey: "lectureFetchCount")

        if ProcessInfo.processInfo.isTesting {
            UserDefaults.standard.signOut()
            UserDefaults.standard.premium = true
            UIView.setAnimationsEnabled(false)
        }

        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        apiRequest.setCookies(cookies)
        isSignedIn = !cookies.isEmpty

        signInViewModel.startSigningIn = { [weak self] in
            Task { @MainActor [weak self] in
                self?.startSigningIn(silently: false)
            }
        }
        scheduleViewModel.checkIfIsSignedIn = { [weak self] error in
            self?.checkIfIsSignedIn(error: error, tab: .schedule)
        }
        gradesViewModel.checkIfIsSignedIn = { [weak self] error in
            self?.checkIfIsSignedIn(error: error, tab: .grades)
        }
        settingsViewModel.checkIfIsSignedIn = { [weak self] error in
            self?.checkIfIsSignedIn(error: error, tab: .settings)
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
    
    private func updateSignInStatus() {
        withAnimation {
            isSignedIn = !cookies.isEmpty
        }
    }
}

extension RootViewModel: @preconcurrency WebAuthenticationPresentationContextProviding {

    func onSignIn(cookies: [HTTPCookie]) {
        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        UserDefaults.standard.cookies = cookies
        apiRequest.setCookies(cookies)

        onError(nil, tab: nil)
        updateSignInStatus()

        reloadData()
    }

    private func checkIfIsSignedIn(error: Error, tab: Tab) {
        Task {
            await checkIfIsSignedIn(error: error, tab: tab)
        }
    }

    private func checkIfIsSignedIn(error: Error, tab: Tab) async {
        guard !isCheckingSignInStatus else { return }
        isCheckingSignInStatus = true

        do {
            let mainHtml = try await apiRequest.getMainHtml()
            let isSignedIn = htmlReader.isSignedIn(fromHtml: mainHtml)
            if isSignedIn {
                onError(error, tab: tab)
            } else {
                await MainActor.run {
                    startSigningIn()
                }
            }
        } catch {
            onError(error, tab: tab)
        }

        isCheckingSignInStatus = false
    }

    func onError(_ error: Error?, tab: Tab?) {
        guard error as? WebAuthenticationSessionError != .cancelled else { return }

        switch tab {
        case .schedule:
            scheduleViewModel.showError(error)
        case .grades:
            gradesViewModel.showError(error)
        case .settings:
            settingsViewModel.showError(error)
        default:
            scheduleViewModel.showError(error)
            gradesViewModel.showError(error)
            settingsViewModel.showError(error)
        }
    }

    @MainActor
    func presentationAnchor(for session: WebAuthenticationSession) -> WebAuthenticationSession.PresentationAnchor? {
        return UIApplication.shared.foregroundActiveScene?.windows.first(where: \.isKeyWindow)
    }

    @MainActor
    func startSigningIn(silently: Bool = true) {
        #if MOCK
        let cookie = HTTPCookie(properties: [
            .name: "ASP.NET_SessionId",
            .value: "mock",
            .domain: "dziekanat.wsei.edu.pl",
            .path: "/"
        ])!
        onSignIn(cookies: [cookie])
        #else
        authSession.start(silently: silently)
        #endif
    }

}
