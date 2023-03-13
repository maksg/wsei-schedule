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

    // MARK: - Initialization

    init(debug: Bool = false) {
        self.debug = debug
    }

    // MARK: - Methods

    func getMainHtml() -> Requestable {
        Request(url: url, endpoint: Endpoint.getMainHtml, debug: debug)
    }

    func getScheduleHtml(parameters: ScheduleParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.getScheduleHtml(parameters: parameters), debug: debug)
    }

    func getGradeSemestersHtml() -> Requestable {
        Request(url: url, endpoint: Endpoint.getGradeSemestersHtml, debug: debug)
    }

    func getGradesHtml(semesterId: String) -> Requestable {
        Request(url: url, endpoint: Endpoint.getGradesHtml(semesterId: semesterId), debug: debug)
    }

    func clearCache() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast, completionHandler: {})
    }

}
