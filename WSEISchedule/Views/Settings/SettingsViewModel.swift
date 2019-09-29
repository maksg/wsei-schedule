//
//  SettingsViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    var albumNumber: String {
        get {
            UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
        }
        set {
            objectWillChange.send()
            UserDefaults.standard.set(newValue, forKey: "AlbumNumber")
        }
    }
    
    var albumNumberPlaceholder: String { "00000" }
}
