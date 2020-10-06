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
    @State private var isSignInViewPresented: Bool = false
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ScheduleView(viewModel: viewModel.scheduleViewModel)
                .tabItem(Tab.schedule.tabItem)
                .tag(Tab.schedule)

            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem(Tab.settings.tabItem)
                .tag(Tab.settings)
        }
        .accentColor(.primary)
        .onAppear(perform: onAppear)
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: SignInViewModel(), onDismiss: viewModel.reloadLectures)
        }
    }
    
    private func onAppear() {
        guard !viewModel.isSignedIn else { return }
        isSignInViewPresented = true
    }
}

struct MainTabView_Previews : PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel())
    }
}
