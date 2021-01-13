//
//  RootView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct RootView: View {

    // MARK: Properties

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var viewModel: RootViewModel
    @State private var isSignInViewPresented: Bool = false

    // MARK: Views

    @ViewBuilder
    private var content: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $viewModel.selectedTab) {
                ScheduleView(viewModel: viewModel.scheduleViewModel)
                    .tabItem(Tab.schedule.tabItem)
                    .tag(Tab.schedule)

                SettingsView(viewModel: viewModel.settingsViewModel, isSignInViewPresented: $isSignInViewPresented)
                    .tabItem(Tab.settings.tabItem)
                    .tag(Tab.settings)
            }
        } else {
            HStack(spacing: 0) {
                ScheduleView(viewModel: viewModel.scheduleViewModel)
                    .frame(minWidth: 500)
                Color.quaternary.frame(width: 1)
                SettingsView(viewModel: viewModel.settingsViewModel, isSignInViewPresented: $isSignInViewPresented)
                    .frame(minWidth: 140, maxWidth: 400)
            }
        }
    }
    
    var body: some View {
        content
            .accentColor(.main)
            .onAppear(perform: onAppear)
            .sheet(isPresented: $isSignInViewPresented) {
                SignInView(viewModel: SignInViewModel(), onDismiss: viewModel.reloadLectures)
            }
    }

    // MARK: Methods
    
    private func onAppear() {
        guard !viewModel.isSignedIn else { return }
        isSignInViewPresented = true
    }

}

struct RootView_Previews : PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
