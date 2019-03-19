//
//  ScheduleCellViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class ScheduleCellViewModel: CellViewModel {
    
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
    
    private var lecture: Lecture
    private(set) var hideDetails: Bool
    
    // MARK: Initialization
    
    init(lecture: Lecture, hideDetails: Bool = true) {
        self.lecture = lecture
        self.hideDetails = hideDetails
    }
    
    // MARK: Methods
    
    private func generateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let fromDate = formatter.string(from: lecture.fromDate)
        let toDate = formatter.string(from: lecture.toDate)
        return "\(fromDate) - \(toDate)"
    }
    
    func toggleDetails() {
        self.hideDetails.toggle()
    }
    
}
