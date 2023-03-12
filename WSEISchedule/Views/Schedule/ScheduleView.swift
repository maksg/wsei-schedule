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
    
    @Environment(\.scenePhase) private var scenePhase: ScenePhase

    @ObservedObject var viewModel: ScheduleViewModel
    @State private var isScheduleHistoryActive: Bool = false

    // MARK: - Views
    
    var body: some View {
        List {
            ScrollToTopView()

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
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
                Text(Translation.Schedule.noLectures.localized)
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
        .onChange(of: scenePhase, perform: onScenePhaseChange)
        .onKeyboardShortcut("r", modifiers: .command, perform: reload)
    }

    // MARK: - Methods

    private func onScenePhaseChange(_ scenePhase: ScenePhase) async {
        guard scenePhase == .active else { return }
        await reload()
    }

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
        ScheduleView(viewModel: ScheduleViewModel(apiRequest: APIRequest(), htmlReader: HTMLReader()))
    }
}
