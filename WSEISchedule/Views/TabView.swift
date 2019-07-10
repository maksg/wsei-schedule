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
//        TabbedView(selection: $viewModel.selectedTab) {
        TabbedView {
            ScheduleView(viewModel: viewModel.scheduleViewModel)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text(Tab.schedule.title)
                }
                .tag(0)
//                .tag(Tab.schedule)
            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text(Tab.settings.title)
                }
                .tag(1)
//                .tag(Tab.settings)
        }
        .accentColor(.primary)
        .edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        TabView(viewModel: .init())
    }
}
#endif
