//
//  APIRequestMock.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class APIRequestMock: APIRequestable {

    func getMainHtml() async throws -> String {
        return contentsOfFile(name: "Main")
    }

    func getScheduleHtml(parameters: ScheduleParameters) async throws -> String {
        let year = Calendar.current.component(.year, from: Date()) + 1
        return contentsOfFile(name: "Schedule").replacingOccurrences(of: "2024", with: String(year))
    }

    func getGradeSemestersHtml() async throws -> String {
        return contentsOfFile(name: "GradeSemesters")
    }

    func getGradesHtml(semesterId: String) async throws -> String {
        return contentsOfFile(name: "Grades")
    }

    func getStudentInfoHtml() async throws -> String {
        return contentsOfFile(name: "StudentInfo")
    }

    func setCookies(_ cookies: [HTTPCookie]) { }

    func clearCache() { }

    private func contentsOfFile(name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "html")!
        let fileUrl = URL(fileURLWithPath: path)
        return try! String(contentsOf: fileUrl)
    }

}
