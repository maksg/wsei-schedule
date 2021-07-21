//
//  ScheduleParameters.swift
//  ScheduleParameters
//
//  Created by Maksymilian Galas on 21/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct ScheduleParameters {

    let fromDate: Date
    let toDate: Date

    var dictionary: [String: String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"

        let from = formatter.string(from: fromDate)
        let to = formatter.string(from: toDate)

        return [
            "parametry": "\(from);\(to);5",
            "DXCallbackName": "gridViewPlanyStudentow"
        ]
    }

}

