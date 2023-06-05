//
//  DataManager.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 02/06/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import CoreData

final class DataManager<T: NSManagedObject> {

    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initialization

    init(persistentContainerName: String) {
        let container = NSSharedPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { _, error in
            guard let error = error as NSError? else { return }
            print("Unresolved error \(error), \(error.userInfo)")
        }
        self.persistentContainer = container
    }

    // MARK: - Methods

    func fetch() throws -> [T] {
        let fetchRequest = T.fetchRequest()
        return try context.fetch(fetchRequest) as! [T]
    }

    func applyContext(_ apply: (NSManagedObjectContext) -> Void) {
        apply(context)
    }

    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    func delete() throws {
        let fetchRequest = T.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
