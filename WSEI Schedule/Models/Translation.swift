//
//  Translation.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class Translation {
    
    enum Alert: String {
        case title = "alert_title"
        case confirm = "alert_confirm"
        case cancel = "alert_cancel"
    }
    
    enum Error: String {
        case title = "error_title"
        case `default` = "error_default"
    }
    
    enum Schedule: String {
        case title = "schedule_title"
    }
    
    enum Settings: String {
        case title = "settings_title"
    }
    
}
