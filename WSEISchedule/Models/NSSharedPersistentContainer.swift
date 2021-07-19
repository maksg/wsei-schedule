//
//  NSSharedPersistentContainer.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 17/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import CoreData

class NSSharedPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.InfinityPi.WSEI-Schedule")
        storeURL = storeURL?.appendingPathComponent("Lectures.sqlite")
        return storeURL!
    }

}
