//
//  ScheduleView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleView : View {
    @State var viewModel: ScheduleViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.lectureDays) { lectureDay in
                Section(header: DayHeader(date: lectureDay.date)) {
                    ForEach(lectureDay.lectures.identified(by: \.self), content: LectureRow.init)
                }
            }
        }
        .onAppear {
            self.viewModel.reloadLectures()
        }
    }
}

#if DEBUG
struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init())
    }
}
#endif
