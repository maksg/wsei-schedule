//
//  SettingsViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI

final class SettingsViewModel: BindableObject {
    let didChange = PassthroughSubject<SettingsViewModel, Never>()
    
    var title: String {
        Tab.settings.title
    }
    
    var albumNumber: String = "" {
        didSet {
            didChange.send(self)
        }
    }
    
}
