//
//  GradeSemester.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 04/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GradeSemester: Identifiable, Codable {
    let id: String
    let order: String
    let name: String
    let status: Status
    var grades: [Grade] = []

    var title: String {
        "\(order) \(name) \(status)"
    }

    init(id: String, text: String) {
        self.id = id

        let rows = text.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        var dictionary = [String: String]()
        rows.forEach { row in
            dictionary.addKey(fromText: row)
        }

        order = dictionary["Semester", "Semestr"] ?? ""
        let summer = Translation.Grades.Semester.summer.localized
        let winter = Translation.Grades.Semester.winter.localized
        name = dictionary["University semester", "Semestr akademicki"]?
            .replacingOccurrences(of: "letni", with: summer)
            .replacingOccurrences(of: "summer", with: summer)
            .replacingOccurrences(of: "zimowy", with: winter)
            .replacingOccurrences(of: "winter", with: winter) ?? ""
        status = Status(value: dictionary["State of semester", "Stan semestru"] ?? "")
    }

    enum Status: Codable {
        case passed
        case inProgress
        case notPassed
        case other(value: String)

        init(value: String) {
            switch value.lowercased() {
            case "zaliczony", "passed":
                self = .passed
            case "w trakcie nauki", "in progress":
                self = .inProgress
            case "niezaliczony", "not passed":
                self = .notPassed
            default:
                self = .other(value: value)
            }
        }

        var title: String {
            switch self {
            case .passed:
                return Translation.Grades.Semester.Status.passed.localized
            case .inProgress:
                return Translation.Grades.Semester.Status.inProgress.localized
            case .notPassed:
                return Translation.Grades.Semester.Status.notPassed.localized
            case .other(let value):
                return value
            }
        }

        var color: Color? {
            switch self {
            case .passed:
                return .main
            case .inProgress:
                return .blue
            case .notPassed:
                return .red
            case .other:
                return nil
            }
        }
    }
}
