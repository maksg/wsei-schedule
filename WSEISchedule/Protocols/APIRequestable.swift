//
//  APIRequestable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

protocol APIRequestable {
    func getMainHtml() -> Requestable
    func getScheduleHtml(parameters: ScheduleParameters) -> Requestable
    func getGradeSemestersHtml() -> Requestable
    func getGradesHtml(semesterId: String) -> Requestable
    func clearCache()
}
