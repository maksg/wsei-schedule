//
//  ScheduleView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ScheduleViewModel
    @State private var isScheduleHistoryActive: Bool = false

    // MARK: - Views
    
    var body: some View {
        List {
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.red)
            }

            if viewModel.lectureWeeks.isEmpty {
                if viewModel.isRefreshing {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text(Translation.Schedule.noLectures.localized)
                }
            } else {
                ForEach(viewModel.lectureWeeks) { lectureWeek in
                    Section {
                        ForEach(lectureWeek.lectureDays) { lectureDay in
                            DayHeader(date: lectureDay.date)
                            ForEach(lectureDay.lectures, id: \.id, content: LectureRow.init)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .pullToRefresh(onRefresh: reload)
        .navigationTitle(Tab.schedule.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ScheduleHistoryView(lectureWeeks: viewModel.previousLectureWeeks)
                } label: {
                    Image.scheduleHistory
                }
            }
        }
        .accessibility(identifier: "ScheduleList")
        .accessibility(hint: Text(Translation.Accessibility.Schedule.upcomingLecturesList.localized))
        .onAppear(perform: reload)
        .onWillEnterForeground(perform: onWillEnterForeground)
    }

    // MARK: - Methods

    private func onWillEnterForeground() async {
        await reload()
    }

    private func reload() async {
        await viewModel.reloadLectures()
    }
    
}

// MARK: -

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel(apiRequest: APIRequest(), htmlReader: HTMLReader()))
    }
}
