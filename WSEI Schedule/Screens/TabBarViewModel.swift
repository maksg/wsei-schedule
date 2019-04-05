//
//  TabBarViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation
import CoreData

class TabBarViewModel: ViewModel {
    
    // MARK: Properties
    
    let persistentContainer: NSPersistentContainer
    let viewModels: [ViewModel]
    
    // MARK: Initialziation
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.viewModels = [ScheduleViewModel(persistentContainer: persistentContainer),
                           SettingsViewModel()]
    }
    
    
}
