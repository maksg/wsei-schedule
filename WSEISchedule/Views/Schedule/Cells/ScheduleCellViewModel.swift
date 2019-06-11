//
//  ScheduleCellViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class ScheduleCellViewModel: CellViewModel {
    
    // MARK: Properties
    
    var subject: String {
        return lecture.subject
    }
    
    var time: String {
        return generateTime()
    }
    
    var classroom: String {
        return lecture.classroom
    }
    
    var lecturer: String {
        return lecture.lecturer
    }
    
    var code: String {
        return lecture.code
    }
    
    var hideDetails: Bool
    
    private var lecture: Lecture
    
    // MARK: Initialization
    
    init(lecture: Lecture) {
        self.lecture = lecture
        self.hideDetails = true
    }
    
    // MARK: Methods
    
    private func generateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let fromDate = formatter.string(from: lecture.fromDate as Date)
        let toDate = formatter.string(from: lecture.toDate as Date)
        return "\(fromDate) - \(toDate)"
    }
    
}
