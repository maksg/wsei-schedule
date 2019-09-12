//
//  MainTabView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ScheduleView(viewModel: viewModel.scheduleViewModel)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text(Tab.schedule.title)
                }
                .tag(Tab.schedule)
            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text(Tab.settings.title)
                }
                .tag(Tab.settings)
        }
        .accentColor(.primary)
        .edgesIgnoringSafeArea(.top)
    }
}

struct MainTabView_Previews : PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: .init())
    }
}
