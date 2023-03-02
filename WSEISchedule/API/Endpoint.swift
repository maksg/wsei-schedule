//
//  Endpoint.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

enum Endpoint: Routable {

    case getMainHtml
    case getScheduleHtml(parameters: ScheduleParameters)
    case getGradesHtml

    var route: Route {
        switch self {
        case .getMainHtml:
            return Route(path: "", method: .get)
        case .getScheduleHtml(let parameters):
            return Route(path: "Plany/PlanyStudentowGridCustom", method: .post, parameters: parameters.dictionary)
        case .getGradesHtml:
            return Route(path: "TokStudiow/StudentPrzedmiotyIOceny/Oceny", method: .get)
        }
    }

}
