//
//  APIRequest.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 14/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import SwiftSoup
import UIKit
import WebKit

final class APIRequest {

    private let url = URL(string: "https://dziekanat.wsei.edu.pl/")!

    func getSignInHtml() -> Requestable {
        return Request(url: url, endpoint: Endpoint.getSignInHtml)
    }

    func signIn(parameters: SignInParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.signIn(parameters: parameters))
    }

    func downloadImage(path: String) -> Requestable {
        let urlString = url.absoluteString.dropLast()
        let url = URL(string: urlString + path)!
        return Request(url: url)
    }

    func getMainHtml() -> Requestable {
        Request(url: url, endpoint: Endpoint.getMainHtml)
    }

    func getScheduleHtml(parameters: ScheduleParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.getScheduleHtml(parameters: parameters))
    }

    func getGradesHtml() -> Requestable {
        Request(url: url, endpoint: Endpoint.getGradesHtml)
    }

    func clearCache() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast, completionHandler: {})
    }

}
