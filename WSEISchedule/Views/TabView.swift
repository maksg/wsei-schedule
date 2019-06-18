//
//  TabView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct TabView: View {
    @ObjectBinding var viewModel: TabViewModel
    
    var body: some View {
        NavigationView {
            TabbedView(selection: $viewModel.selectedTab) {
                ScheduleView(viewModel: viewModel.scheduleViewModel)
                    .tabItemLabel(Image("timetable"))
                    .tabItemLabel(Image(systemName: "clock.fill"))
                    .tabItemLabel(Text(Tab.schedule.title))
                    .tag(Tab.schedule)
                SettingsView(viewModel: viewModel.settingsViewModel)
                    .tabItemLabel(Image("settings"))
                    .tabItemLabel(Image(systemName: "gear"))
                    .tabItemLabel(Text(Tab.settings.title))
                    .tag(Tab.settings)
            }
            .accentColor(.primary)
            .navigationBarTitle(Text("\(viewModel.selectedTab.title)"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        TabView(viewModel: .init())
    }
}
#endif
