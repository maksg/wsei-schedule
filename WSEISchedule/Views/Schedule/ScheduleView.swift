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
            ScrollToTopView()

            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.red)
            }

            if viewModel.isRefreshing {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .id(UUID())
            }

            if viewModel.lectureWeeks.isEmpty {
                Text(.schedule(.noLectures))
            } else {
                ForEach(viewModel.lectureWeeks) { lectureWeek in
                    Section {
                        ForEach(lectureWeek.lectureDays) { lectureDay in
                            DayHeader(date: lectureDay.date)
                            ForEach(lectureDay.lectures) { lecture in
                                LectureRow(lecture: lecture, showDetails: viewModel.showDetails(for: lecture))
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .pullToRefresh(onRefresh: pullToRefresh)
        .navigationTitle(Tab.schedule.title)
        .toolbar {
            #if targetEnvironment(macCatalyst)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    await reload()
                } label: {
                    Image.refresh
                }
            }
            #endif
            ToolbarItem(placement: .navigationBarTrailing) {
                if #available(iOS 16.0, *) {
                    NavigationLink(value: "ScheduleHistory") {
                        Image.scheduleHistory
                    }
                    .navigationDestination(for: String.self) { _ in
                        ScheduleHistoryView(lectureWeeks: viewModel.previousLectureWeeks)
                    }
                    .accessibilityIdentifier("ScheduleHistory")
                } else {
                    NavigationLink {
                        ScheduleHistoryView(lectureWeeks: viewModel.previousLectureWeeks)
                    } label: {
                        Image.scheduleHistory
                    }
                    .accessibilityIdentifier("ScheduleHistory")
                }
            }
        }
        .accessibilityIdentifier("ScheduleList")
        .accessibilityHint(Text(.accessibility(.scheduleUpcomingLecturesList)))
        .onKeyboardShortcut("r", perform: reload)
    }

    // MARK: - Methods

    private func reload() async {
        await viewModel.reload()
    }

    private func pullToRefresh() async {
        await viewModel.fetchSchedule(showRefreshControl: false)
    }
    
}

// MARK: -

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel(apiRequest: APIRequestMock(), htmlReader: HTMLReader()))
    }
}
