//
//  LectureDay.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureDay: Identifiable {
    var id: Date { date }
    let date: Date
    var lectures: [Lecture] = []
}

extension Array where Element == LectureDay {
    subscript(date: Date) -> LectureDay {
        get {
            first(where: { $0.date == date }) ?? LectureDay(date: date)
        }
        set {
            if let index = firstIndex(where: { $0.date == date }) {
                self[index] = newValue
            } else {
                append(newValue)
            }
        }
    }
}
