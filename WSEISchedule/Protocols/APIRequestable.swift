//
//  APIRequestable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

protocol APIRequestable {
    func getMainHtml() async throws -> String
    func getScheduleHtml(parameters: ScheduleParameters) async throws -> String
    func getGradeSemestersHtml() async throws -> String
    func getGradesHtml(semesterId: String) async throws -> String
    func getStudentInfoHtml() async throws -> String
    func clearCache()
}
