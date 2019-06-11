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
class Lecture: NSManagedObject {
    
    convenience init(fromDictionary dictionary: [String : String], inContext context: NSManagedObjectContext) {
        self.init(context: context)
        
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
