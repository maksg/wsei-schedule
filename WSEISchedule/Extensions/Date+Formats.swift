//
//  Date+Formats.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension Date {
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd.MM"
        return formatter.string(from: self)
    }
    
    var shortHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
}
