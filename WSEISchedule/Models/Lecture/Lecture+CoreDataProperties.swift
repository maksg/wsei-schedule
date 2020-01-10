//
//  Lecture+CoreDataProperties.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//
//

import Foundation
import CoreData

extension Lecture {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged var lecturer: String
    @NSManaged var classroom: String
    @NSManaged var fromDate: Date
    @NSManaged var toDate: Date
    @NSManaged var code: String
    @NSManaged var subject: String

}
