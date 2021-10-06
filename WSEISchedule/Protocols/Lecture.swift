//
//  Lecture.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

protocol Lecture {

    var lecturer: String { get }
    var classroom: String { get }
    var fromDate: Date { get }
    var toDate: Date { get }
    var code: String { get }
    var subject: String { get }
    var comments: String { get }
    
}

extension Lecture {
    
    var id: String {
        fromDate.description + code
    }
    
}
