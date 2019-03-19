//
//  Lecture.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

struct Lecture {
    
    var fromDate: Date
    var toDate: Date
    var subject: String
    var classroom: String
    var lecturer: String
    var code: String
    
    init(fromDictionary dictionary: [String : String]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date = dictionary["Data"] ?? ""
        let fromTime = dictionary["Od"] ?? ""
        let toTime = dictionary["Do"] ?? ""
        
        self.fromDate = formatter.date(from: "\(date) \(fromTime)") ?? Date()
        self.toDate = formatter.date(from: "\(date) \(toTime)") ?? Date()
        self.subject = dictionary["Przedmiot"] ?? ""
        self.classroom = dictionary["Sala"] ?? ""
        self.lecturer = dictionary["Wykładowca"] ?? ""
        self.code = dictionary["Kod zajęć"] ?? ""
    }
    
}
