//
//  SettingsViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class SettingsViewModel: ViewModel {
    
    var title: String {
        return Translation.Settings.title.localized
    }
    
    init() {
    }
    
}
