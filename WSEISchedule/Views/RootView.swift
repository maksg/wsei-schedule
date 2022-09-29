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

    // MARK: Views

    @ViewBuilder
    private var content: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $viewModel.selectedTab) {
                NavigationView {
                    ScheduleView(viewModel: viewModel.scheduleViewModel)
                }
                .tabItem(Tab.schedule.tabItem)
                .tag(Tab.schedule)

                NavigationView {
                    GradesView(viewModel: viewModel.gradesViewModel)
                }
                .tabItem(Tab.grades.tabItem)
                .tag(Tab.grades)

                NavigationView {
                    SettingsView(viewModel: viewModel.settingsViewModel, isSignedIn: $viewModel.isSignedIn)
                }
                .tabItem(Tab.settings.tabItem)
                .tag(Tab.settings)
            }.accentColor(.main)
        } else {
            NavigationView {
                List(selection: $viewModel.selectedListItem) {
                    NavigationLink {
                        ScheduleView(viewModel: viewModel.scheduleViewModel)
                    } label: {
                        Tab.schedule.label
                    }
                    .tag(Tab.schedule)

                    NavigationLink {
                        GradesView(viewModel: viewModel.gradesViewModel)
                    } label: {
                        Tab.grades.label
                    }
                    .tag(Tab.grades)
                    SettingsViewContent(viewModel: viewModel.settingsViewModel, isSignedIn: $viewModel.isSignedIn)
                }
                .listStyle(.insetGrouped)
                .navigationTitle(Translation.wseiSchedule.localized)

                switch viewModel.selectedListItem {
                case .grades:
                    GradesView(viewModel: viewModel.gradesViewModel)
                default:
                    ScheduleView(viewModel: viewModel.scheduleViewModel)
                }
            }.accentColor(.main)
        }
    }
    
    var body: some View {
        if viewModel.isSignedIn {
            content
        } else {
            SignInView(viewModel: viewModel.signInViewModel)
                .transition(.move(edge: .bottom))
        }
    }

}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
