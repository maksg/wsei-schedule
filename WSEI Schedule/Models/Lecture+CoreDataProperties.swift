//
//  Lecture+CoreDataProperties.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 05/04/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//
//

import Foundation
import CoreData

extension Lecture {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Lecture> {
        return NSFetchRequest<Lecture>(entityName: "Lecture")
    }

    @NSManaged var classroom: String
    @NSManaged var code: String
    @NSManaged var fromDate: Date
    @NSManaged var lecturer: String
    @NSManaged var subject: String
    @NSManaged var toDate: Date

}
