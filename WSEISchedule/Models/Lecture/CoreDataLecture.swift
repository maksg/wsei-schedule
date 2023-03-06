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

final class CoreDataLecture: NSManagedObject {

    class func fetchRequest() -> NSFetchRequest<CoreDataLecture> {
        NSFetchRequest(entityName: "Lecture")
    }

    @NSManaged var lecturer: String?
    @NSManaged var classroom: String?
    @NSManaged var fromDate: Date?
    @NSManaged var toDate: Date?
    @NSManaged var code: String?
    @NSManaged var subject: String?
    @NSManaged var comments: String?
    
    convenience init(fromDictionary dictionary: [String : String], in context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Lecture", in: context)!
        self.init(entity: entity, insertInto: context)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Europe/Warsaw")
        
        let date = dictionary["Data Zajęć"]?.split(separator: " ").first ?? ""
        let fromTime = dictionary["Czas od"] ?? ""
        let toTime = dictionary["Czas do"] ?? ""
        
        self.fromDate = formatter.date(from: "\(date) \(fromTime)")
        self.toDate = formatter.date(from: "\(date) \(toTime)")
        self.subject = dictionary["Zajęcia"]
        self.classroom = dictionary["Sala"]
        self.lecturer = dictionary["Prowadzący"]
        self.code = dictionary["Grupy"]
        self.comments = dictionary["Uwagi"]
    }

}
