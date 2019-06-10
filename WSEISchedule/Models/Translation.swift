//
//  Translation.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class Translation {
    
    enum Alert: String {
        case title = "alert.title"
        case confirm = "alert.confirm"
        case cancel = "alert.cancel"
    }
    
    enum Error: String {
        case title = "error.title"
        case `default` = "error.default"
    }
    
    enum Schedule: String {
        case title = "schedule.title"
    }
    
    enum Settings: String {
        case title = "settings.title"
        case albumNumber = "settings.album_number"
    }
    
}
