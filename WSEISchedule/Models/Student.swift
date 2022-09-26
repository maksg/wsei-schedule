//
//  Student.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var albumNumber: String
    var courseName: String
    var photoUrl: URL?
}
