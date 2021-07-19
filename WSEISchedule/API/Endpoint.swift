//
//  Endpoint.swift
//  Offer Sniper
//
//  Created by Maksymilian Galas on 13/07/2021.
//

import Foundation

enum Endpoint: Routable {

    case getSignInPageHtml
    case signIn(parameters: SignInParameters)

    var route: Route {
        switch self {
        case .getSignInPageHtml:
            return Route(path: "Konto/LogowanieStudenta", method: .get)
        case .signIn(let parameters):
            return Route(path: "Konto/LogowanieStudenta", method: .post, parameters: parameters.dictionary)
        }
    }

}
