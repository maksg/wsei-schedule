//
//  ScheduleView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleView : View, TabBarItemable {
    
    var tabBarItem: UITabBarItem { UITabBarItem(title: Tab.schedule.title, image: .schedule, tag: 0) }
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(.systemBackground))
                        .background(Color(.systemRed))
                        .animation(.default)
                        .transition(.move(edge: .top))
                }
                List {
                    ForEach(viewModel.lectureDays) { lectureDay in
                        Section(header: DayHeader(date: lectureDay.date)) {
                            ForEach(lectureDay.lectures, id: \.id, content: LectureRow.init)
                                .animation(.easeInOut)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .onAppear(perform: viewModel.reloadLectures)
            .navigationBarTitle(Tab.schedule.title)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init(webView: ScheduleWebView()))
    }
}
