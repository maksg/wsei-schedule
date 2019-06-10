//
//  ScheduleViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import CoreData

final class ScheduleViewModel: ViewModel {
    
    // MARK: Properties
    
    var scheduleURL: URL {
        URL(string: "https://estudent.wsei.edu.pl/SG/PublicDesktop.aspx?fileShareToken=95-88-6B-EB-B0-75-96-FB-A9-7C-AE-D7-5C-DB-90-49")!
    }
    
    var albumNumber: String {
        UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
    }
    
    var title: String {
        Tab.schedule.title
    }
    
}
