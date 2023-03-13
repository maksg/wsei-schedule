//
//  RequestMock.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class RequestMock: Requestable {

    // MARK: - Properties

    private let response: String

    // MARK: - Initialization

    init(response: String) {
        self.response = response
    }

    // MARK: - Methods

    func make() async throws -> String {
        return response
    }

}

