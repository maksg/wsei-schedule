//
//  TabBarViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class TabBarViewModel: ViewModel {
    
    // MARK: Properties
    
    var viewModels: [ViewModel]
    
    // MARK: Initialziation
    
    init() {
        self.viewModels = [ScheduleViewModel(),
                           SettingsViewModel()]
    }
    
    
}
