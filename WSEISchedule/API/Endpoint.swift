//
//  Endpoint.swift
//  Offer Sniper
//
//  Created by Maksymilian Galas on 13/07/2021.
//

import Foundation

enum Endpoint: Routable {

    case getSignInHtml
    case signIn(parameters: SignInParameters)
    case getMainHtml
    case getScheduleHtml(parameters: ScheduleParameters)
    case getMarksHtml

    var route: Route {
        switch self {
        case .getSignInHtml:
            return Route(path: "Konto/LogowanieStudenta", method: .get)
        case .signIn(let parameters):
            return Route(path: "Konto/LogowanieStudenta", method: .post, parameters: parameters.dictionary)
        case .getMainHtml:
            return Route(path: "", method: .get)
        case .getScheduleHtml(let parameters):
            return Route(path: "Plany/PlanyStudentowGridCustom", method: .post, parameters: parameters.dictionary)
        case .getMarksHtml:
            return Route(path: "TokStudiow/StudentPrzedmiotyIOceny/Oceny", method: .get)
        }
    }

}
