//
//  Student.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct Student: Codable {
    let name: String
    let albumNumber: String
    let courseName: String
    let photoSource: String?
}

extension Student {
    init() {
        name = ""
        albumNumber = ""
        courseName = ""
        photoSource = nil
    }
}
