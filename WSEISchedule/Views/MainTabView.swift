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
        TabBarView<Tab, Any>(selection: $viewModel.selectedTab) {
            TupleView((
                ScheduleView(viewModel: viewModel.scheduleViewModel),
                SettingsView(viewModel: viewModel.settingsViewModel)
            ))
        }
        .accentColor(.primary)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainTabView_Previews : PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: .init())
    }
}
