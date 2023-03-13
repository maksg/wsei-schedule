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
        authSession.onFailure = { [weak self] error in self?.onError(error) }
        authSession.presentationContextProvider = self

        // TODO: Remove once everyone migrates
        Keychain.clean()

        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        isSignedIn = !cookies.isEmpty

        signInViewModel.startSigningIn = { [weak self] in self?.startSigningIn(silently: false) }
        scheduleViewModel.checkIfIsSignedIn = { [weak self] error in self?.checkIfIsSignedIn(error: error) }
        gradesViewModel.checkIfIsSignedIn = { [weak self] error in self?.checkIfIsSignedIn(error: error) }
        settingsViewModel.checkIfIsSignedIn = { [weak self] error in self?.checkIfIsSignedIn(error: error) }
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

extension RootViewModel: WebAuthenticationPresentationContextProviding {

    func onSignIn(cookies: [HTTPCookie]) {
        cookies.forEach(HTTPCookieStorage.shared.setCookie)
        UserDefaults.standard.cookies = cookies

        onError(nil)
        updateSignInStatus()
        reloadData()
    }

    private func checkIfIsSignedIn(error: Error) {
        Task {
            await checkIfIsSignedIn(error: error)
        }
    }

    private func checkIfIsSignedIn(error: Error) async {
        do {
            let mainHtml = try await apiRequest.getMainHtml().make()
            let isSignedIn = htmlReader.isSignedIn(fromHtml: mainHtml)
            if isSignedIn {
                onError(error)
            } else {
                startSigningIn()
            }
        } catch {
            onError(error)
        }
    }

    func onError(_ error: Error?) {
        guard error as? WebAuthenticationSessionError != .cancelled else { return }
        scheduleViewModel.showError(error)
        gradesViewModel.showError(error)
        settingsViewModel.showError(error)
    }

    func presentationAnchor(for session: WebAuthenticationSession) -> WebAuthenticationSession.PresentationAnchor? {
        return UIApplication.shared.foregroundActiveScene?.windows.first(where: \.isKeyWindow)
    }

    func startSigningIn(silently: Bool = true) {
        authSession.start(silently: silently)
    }

}
