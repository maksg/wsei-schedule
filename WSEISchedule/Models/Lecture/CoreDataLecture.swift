//
//  CoreDataLecture.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Lecture)
final class CoreDataLecture: NSManagedObject, Lecture {
    
    convenience init(fromDictionary dictionary: [String : String], inContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Lecture", in: context)!
        self.init(entity: entity, insertInto: context)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Europe/Warsaw")
        
        let date = dictionary["Data Zajęć"]?.split(separator: " ").first ?? ""
        let fromTime = dictionary["Czas od"] ?? ""
        let toTime = dictionary["Czas do"] ?? ""
        
        self.fromDate = formatter.date(from: "\(date) \(fromTime)") ?? Date()
        self.toDate = formatter.date(from: "\(date) \(toTime)") ?? Date()
        self.subject = dictionary["Zajęcia"] ?? ""
        self.classroom = dictionary["Sala"] ?? ""
        self.lecturer = dictionary["Prowadzący"] ?? ""
        self.code = dictionary["Grupy"] ?? ""
        self.comments = dictionary["Uwagi"] ?? ""
    }

}
