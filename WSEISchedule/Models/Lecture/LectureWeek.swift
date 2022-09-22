//
//  LectureDay.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureWeek: Identifiable {
    var id: Date { date }
    let date: Date
    var lectureDays: [LectureDay] = []
}

extension Array where Element == LectureWeek {
    subscript(date: Date) -> LectureWeek {
        get {
            let startOfWeek = date.startOfWeek
            return first(where: { $0.date == startOfWeek }) ?? LectureWeek(date: startOfWeek)
        }
        set {
            let startOfWeek = date.startOfWeek
            if let index = firstIndex(where: { $0.date == startOfWeek }) {
                self[index] = newValue
            } else {
                append(newValue)
            }
        }
    }
}
