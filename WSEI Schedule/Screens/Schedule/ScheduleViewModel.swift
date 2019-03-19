//
//  ScheduleViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

class ScheduleViewModel: ViewModel {
    
    // MARK: Properties
    
    var scheduleURL: URL {
        return URL(string: "https://estudent.wsei.edu.pl/SG/PublicDesktop.aspx?fileShareToken=95-88-6B-EB-B0-75-96-FB-A9-7C-AE-D7-5C-DB-90-49")!
    }
    
    var title: String {
        return Translation.Schedule.title.localized
    }
    
    var lectures: [Lecture]
    
    var scheduleCellViewModels: [Date : [ScheduleCellViewModel]]
    
    // MARK: Initialization
    
    init() {
        self.lectures = []
        self.scheduleCellViewModels = [:]
    }
    
    // MARK: Methods
    
    func convertDataToLectureList(data: Any?) {
        guard let data = data as? [[String : String]] else { return }
        
        let filteredData = data.map { (lecture) -> [String : String] in
            Dictionary(uniqueKeysWithValues: lecture.compactMap({ (key, value) -> (String, String)? in
                let splitValue = value.split(separator: ":", maxSplits: 1)
                guard splitValue.count > 0 else { return nil }
                return (String(splitValue[0].trimmingCharacters(in: .whitespacesAndNewlines)), String(splitValue[1].trimmingCharacters(in: .whitespacesAndNewlines)))
            }))
        }
        
        lectures = filteredData.map { Lecture(fromDictionary: $0) }
        scheduleCellViewModels = lectures.reduce(into: [Date : [ScheduleCellViewModel]]()) {
            let viewModel = ScheduleCellViewModel(lecture: $1)
            let date = $1.fromDate.strippedFromTime
            if $0[date] == nil {
                $0[date] = [viewModel]
            } else {
                $0[date]! += [viewModel]
            }
            
        }
    }
    
}
