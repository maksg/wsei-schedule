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
        NavigationView {
            VStack {
                viewModel.webView
                    .frame(height: 300)
            }
//            List {
//                ForEach(viewModel.lectureDays) { lectureDay in
//                    Section(header: DayHeader(date: lectureDay.date)) {
//                        ForEach(lectureDay.lectures as? [Lecture] ?? [], id: \.self, content: LectureRow.init)
//                    }
//                }
//            }
            .onAppear {
                self.viewModel.reloadLectures()
            }
            .navigationBarTitle(Tab.schedule.title)
        }
    }
}

struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init())
    }
}
