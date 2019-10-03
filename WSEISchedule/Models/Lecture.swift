//
//  Lecture.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Lecture)
final class Lecture: NSManagedObject, LectureProtocol {
    
    convenience init(fromDictionary dictionary: [String : String], inContext context: NSManagedObjectContext) {
        self.init(context: context)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date = String(dictionary["Data Zajęć"]?.split(separator: " ").first ?? "")
        let fromTime = dictionary["Czas od"] ?? ""
        let toTime = dictionary["Czas do"] ?? ""
        
        self.fromDate = formatter.date(from: "\(date) \(fromTime)") ?? Date()
        self.toDate = formatter.date(from: "\(date) \(toTime)") ?? Date()
        self.subject = dictionary["Przedmiot"] ?? ""
        self.classroom = dictionary["Sala"]?.replacingOccurrences(of: "F ", with: "") ?? ""
        self.lecturer = dictionary["Prowadzący"] ?? ""
        self.code = dictionary["Grupy"] ?? ""
    }

}
