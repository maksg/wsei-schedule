//
//  Requestable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

protocol Requestable {
    func make(session: URLSession) async throws -> String
}

