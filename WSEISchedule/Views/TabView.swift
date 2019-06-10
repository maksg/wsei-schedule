//
//  TabView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct TabView: View {
    var currentTab: Tab = .schedule
    var viewModel: TabViewModel
    
    var body: some View {
        TabbedView {
            ScheduleView(.init())
                .tabItemLabel(Image("timetable"))
                .tabItemLabel(Text(Tab.schedule.title))
                .tag(Tab.schedule.rawValue)
            SettingsView(viewModel: .init())
                .tabItemLabel(Image("settings"))
                .tabItemLabel(Text(Tab.settings.title))
                .tag(Tab.settings.rawValue)
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
