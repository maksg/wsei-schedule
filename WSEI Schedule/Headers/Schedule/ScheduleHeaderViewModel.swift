//
//  ScheduleHeaderViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class ScheduleHeaderViewModel: ViewModel {
    
    // MARK: Properties
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd.MM"
        return formatter.string(from: date)
    }
    
    private var date: Date
    
    // MARK: Initialization
    
    init(date: Date) {
        self.date = date
    }
    
}
