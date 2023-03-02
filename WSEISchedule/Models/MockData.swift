//
//  MockData.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class MockData {
    static let lecture = CodableLecture(lecturer: "Lecturer", classroom: "Classroom", fromDate: Date(), toDate: Date(), code: "Code", subject: "Subject", comments: "Comments")
    static let grade = Grade(subject: "Subject", lecturer: "Lecturer", lectureForm: "Consultations", ects: "8", value: "4,5")
}
