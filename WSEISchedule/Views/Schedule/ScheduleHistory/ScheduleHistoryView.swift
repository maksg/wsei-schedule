//
//  ScheduleHistoryView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 29/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleHistoryView: View {

    // MARK: - Properties

    @AppStorage(UserDefaults.Key.premium.rawValue) var isPremium: Bool = false
    let lectureWeeks: [LectureWeek]

    // MARK: - Views

    var body: some View {
        if isPremium {
            List {
                ForEach(lectureWeeks) { lectureWeek in
                    Section {
                        ForEach(lectureWeek.lectureDays) { lectureDay in
                            DayHeader(date: lectureDay.date)
                            ForEach(lectureDay.lectures, content: LectureRow.init)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(.scheduleHistory(.title))
            .accessibilityHint(Text(.accessibility(.scheduleHistoryList)))
        } else {
            PremiumView()
        }
    }

}

struct ScheduleHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleHistoryView(lectureWeeks: [LectureWeek(date: Date(), lectureDays: [LectureDay(date: Date(), lectures: [MockData.lecture])])])
    }
}
