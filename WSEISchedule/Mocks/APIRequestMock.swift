//
//  APIRequestMock.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class APIRequestMock: APIRequestable {

    func getMainHtml() -> Requestable {
        let response = contentsOfFile(name: "Main")
        return RequestMock(response: response)
    }

    func getScheduleHtml(parameters: ScheduleParameters) -> Requestable {
        let response = contentsOfFile(name: "Schedule")
        return RequestMock(response: response)
    }

    func getGradeSemestersHtml() -> Requestable {
        let response = contentsOfFile(name: "GradeSemesters")
        return RequestMock(response: response)
    }

    func getGradesHtml(semesterId: String) -> Requestable {
        let response = contentsOfFile(name: "Grades")
        return RequestMock(response: response)
    }

    func clearCache() { }

    private func contentsOfFile(name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "html")!
        let fileUrl = URL(fileURLWithPath: path)
        return try! String(contentsOf: fileUrl)
    }

}
