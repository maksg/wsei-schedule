//
//  SettingsViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import CoreData

final class SettingsViewModel: ObservableObject {
    
    var isSignedIn: Bool { !UserDefaults.standard.login.isEmpty }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func removeAllLectures() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        let context = persistentContainer.viewContext
        
        do {
            let lectures = try context.fetch(fetchRequest) as? [Lecture]
            lectures?.forEach { lecture in
                context.delete(lecture)
            }
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func signOut() {
        removeAllLectures()
        UserDefaults.standard.signOut()
    }
    
}
