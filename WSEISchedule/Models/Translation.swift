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
        case today = "schedule.today"
        case tomorrow = "schedule.tomorrow"
    }
    
    enum Settings: String {
        case title = "settings.title"
        case albumNumber = "settings.album_number"
    }
    
    enum Widget: String {
        case next = "widget.next"
        case today = "widget.today"
        case tomorrow = "widget.tomorrow"
        case noLecturesToday = "widget.no_lectures_today"
        case noNextLectures = "widget.no_next_lectures"
    }
    
    enum Watch: String {
        case today = "watch.today"
        case noLectures = "watch.no_lectures"
        case noLecturesToday = "watch.no_lectures_today"
    }
    
}
