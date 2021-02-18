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
        if isToday || isTomorrow {
            let formatter = DateFormatter()
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE dd.MM"
            return formatter.string(from: self)
        }
    }

    var voiceOverDay: String {
        if isToday || isTomorrow {
            let formatter = DateFormatter()
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEdMMMM", options: 0, locale: .current)
            return formatter.string(from: self)
        }
    }
    
    var shortHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter.string(from: self)
    }

    var voiceOverHour: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        return DateComponentsFormatter.localizedString(from: components, unitsStyle: .spellOut) ?? ""
    }
    
    var strippedFromTime: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
}
