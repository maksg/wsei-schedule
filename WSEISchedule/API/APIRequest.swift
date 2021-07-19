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

    private let url = URL(string: "https://dziekanat.wsei.edu.pl/")!

    func getSignInPageHtml() -> Requestable {
        let request = Request(url: url, endpoint: Endpoint.getSignInPageHtml)
        request.clearCookies()
        return request
    }

    func signIn(parameters: SignInParameters) -> Requestable {
        Request(url: url, endpoint: Endpoint.signIn(parameters: parameters))
    }

    func downloadCaptcha(path: String) -> Requestable {
        var path = path
        if path.first == "/" {
            path.removeFirst()
        }

        let urlString = url.absoluteString + path

        return Request(url: URL(string: urlString)!)
    }

}
