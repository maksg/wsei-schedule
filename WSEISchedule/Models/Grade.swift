//
//  Grade.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct Grade: Identifiable {
    let id: String
    let subject: String
    let lecturer: String
    let value: String
}

extension Grade {
    init(fromDictionary dictionary: [String: String]) {
        self.id = dictionary["Nr"] ?? ""

        let subjectAndLecturer = dictionary["Przedmiot i prowadzący"]?
            .replacingOccurrences(of: "\\n", with: "\n")
            .split(separator: "\n")
            .map({ $0.trimmingCharacters(in: .whitespaces) }) ?? []

        if subjectAndLecturer.count >= 2 {
            self.subject = subjectAndLecturer[0]
            self.lecturer = subjectAndLecturer[1]
        } else {
            self.subject = subjectAndLecturer.first ?? ""
            self.lecturer = ""
        }

        self.value = dictionary["Ocena"] ?? ""
    }
}
