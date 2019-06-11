//
//  TabView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct TabView: View {
    var body: some View {
        TabbedView {
            ScheduleView(viewModel: .init())
                .tabItemLabel(Image("timetable"))
                .tabItemLabel(Image(systemName: "clock.fill"))
                .tabItemLabel(Text(Tab.schedule.title))
                .tag(Tab.schedule.rawValue)
            SettingsView(viewModel: .init())
                .tabItemLabel(Image("settings"))
                .tabItemLabel(Image(systemName: "gear"))
                .tabItemLabel(Text(Tab.settings.title))
                .tag(Tab.settings.rawValue)
        }
        .accentColor(.green)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
#endif
