//
//  APIRequest.swift
//  Offer Sniper
//
//  Created by Maksymilian Galas on 14/07/2021.
//

import Foundation
import SwiftSoup
import UIKit

final class APIRequest {

    private let url = URL(string: "https://dziekanat.wsei.edu.pl")!

    func getSignInHtml() -> Requestable {
        clearCookies()
        return Request(url: url, endpoint: Endpoint.getSignInHtml)
    }

    func signIn(parameters: SignInParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.signIn(parameters: parameters))
    }

    func downloadImage(path: String) -> Requestable {
        let url = URL(string: url.absoluteString + path)!
        return Request(url: url)
    }

    func getMainHtml() -> Requestable {
        Request(url: url, endpoint: Endpoint.getMainHtml)
    }

    func getScheduleHtml(parameters: ScheduleParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.getScheduleHtml(parameters: parameters))
    }

    func clearCookies() {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }

}
