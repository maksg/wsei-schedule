//
//  Lecture.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct Lecture: Codable, Identifiable {
    var id: String {
        fromDate.description + code
    }

    let lecturer: String
    let classroom: String
    let fromDate: Date
    let toDate: Date
    let code: String
    let subject: String
    let comments: String
}

extension Lecture {

    init?(lecture: CoreDataLecture) {
        guard
            let lecturer = lecture.lecturer,
            let classroom = lecture.classroom,
            let fromDate = lecture.fromDate,
            let toDate = lecture.toDate,
            let code = lecture.code,
            let subject = lecture.subject,
            let comments = lecture.comments
        else { return nil }
        self.init(lecturer: lecturer, classroom: classroom, fromDate: fromDate, toDate: toDate, code: code, subject: subject, comments: comments)
    }

}

extension Array where Element == Lecture {
    var encoded: Data? {
        try? PropertyListEncoder().encode(self)
    }

    init?(data: Data) {
        guard let lecures = try? PropertyListDecoder().decode([Lecture].self, from: data) else { return nil }
        self = lecures
    }
}
