//
//  ScheduleView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {

    // MARK: Properties

    @ObservedObject var viewModel: ScheduleViewModel

    // MARK: Views
    
    var body: some View {
        NavigationView {
            List {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .listRowBackground(Color.red)
                }
                ForEach(viewModel.lectureDays) { lectureDay in
                    Section(header: DayHeader(date: lectureDay.date)) {
                        ForEach(lectureDay.lectures, id: \.id, content: LectureRow.init)
                            .animation(.easeInOut)
                    }
                }
            }
            .insetGroupedListStyle()
            .pullToRefresh(onRefresh: viewModel.reloadLectures, isRefreshing: $viewModel.isRefreshing)
            .onAppear(perform: viewModel.reloadLectures)
            .navigationBarTitle(Tab.schedule.title)
            .accessibility(identifier: "ScheduleList")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel(webView: ScheduleWebView()))
    }
}
