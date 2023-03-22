//
//  APIRequest.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 14/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import WebKit

final class APIRequest: APIRequestable {

    // MARK: - Properties

    private let url = URL(string: "https://dziekanat.wsei.edu.pl/")!
    private let debug: Bool
    private var session: URLSession

    // MARK: - Initialization

    init(debug: Bool = false) {
        self.debug = debug
        self.session = URLSession(configuration: .ephemeral)
    }

    // MARK: - Methods

    func getMainHtml() async throws -> String {
        return try await makeRequest(endpoint: .getMainHtml)
    }

    func getScheduleHtml(parameters: ScheduleParameters) async throws -> String {
        return try await makeRequest(endpoint: .getScheduleHtml(parameters: parameters))
    }

    func getGradeSemestersHtml() async throws -> String {
        return try await makeRequest(endpoint: .getGradeSemestersHtml)
    }

    func getGradesHtml(semesterId: String) async throws -> String {
        return try await makeRequest(endpoint: .getGradesHtml(semesterId: semesterId))
    }

    func getStudentInfoHtml() async throws -> String {
        return try await makeRequest(endpoint: .getStudentInfoHtml)
    }

    private func makeRequest(endpoint: Endpoint) async throws -> String {
        let request = Request(url: url, endpoint: endpoint, debug: debug)
        return try await request.make(session: session)
    }

    func setCookies(_ cookies: [HTTPCookie]) {
        cookies.forEach { cookie in
            session.configuration.httpCookieStorage?.setCookie(cookie)
        }
    }

    func clearCache() {
        session = URLSession(configuration: .ephemeral)
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast, completionHandler: {})
    }

}
