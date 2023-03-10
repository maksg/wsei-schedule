//
//  RootView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct RootView: View {

    // MARK: - Properties

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var viewModel: RootViewModel

    // MARK: - Views

    private var scheduleView: some View {
        ScheduleView(viewModel: viewModel.scheduleViewModel)
            .scrollToTop(viewModel.$scrollToTop, condition: { viewModel.selectedTab == .schedule })
    }

    private var gradesView: some View {
        GradesView(viewModel: viewModel.gradesViewModel)
            .scrollToTop(viewModel.$scrollToTop, condition: { viewModel.selectedTab == .grades })
    }

    @available(iOS 16.0, *)
    struct NewNavigationSplitView: View {
        @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
        @ObservedObject var viewModel: RootViewModel

        var body: some View {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                List(selection: $viewModel.selectedListItem) {
                    NavigationLink(value: Tab.schedule) {
                        Tab.schedule.label
                    }

                    NavigationLink(value: Tab.grades) {
                        Tab.grades.label
                    }

                    SettingsViewContent(viewModel: viewModel.settingsViewModel, isSignedIn: $viewModel.isSignedIn)
                }
                .listStyle(.insetGrouped)
                .navigationTitle(Translation.wseiSchedule.localized)
            } detail: {
                switch viewModel.selectedListItem {
                case .grades:
                    NavigationStack {
                        GradesView(viewModel: viewModel.gradesViewModel)
                    }
                default:
                    NavigationStack {
                        ScheduleView(viewModel: viewModel.scheduleViewModel)
                    }
                }
            }
            .navigationSplitViewStyle(.balanced)
            .accentColor(.main)
        }
    }

    @ViewBuilder
    private var content: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $viewModel.selectedTab) {
                NavigationView {
                    scheduleView
                }
                .tabItem(Tab.schedule.tabItem)
                .tag(Tab.schedule)

                NavigationView {
                    gradesView
                }
                .tabItem(Tab.grades.tabItem)
                .tag(Tab.grades)

                NavigationView {
                    SettingsView(viewModel: viewModel.settingsViewModel, isSignedIn: $viewModel.isSignedIn)
                }
                .tabItem(Tab.settings.tabItem)
                .tag(Tab.settings)
            }
            .accentColor(.main)
        } else {
            if #available(iOS 16.0, *) {
                NewNavigationSplitView(viewModel: viewModel)
            } else {
                NavigationView {
                    List(selection: $viewModel.selectedListItem) {
                        NavigationLink {
                            scheduleView
                        } label: {
                            Tab.schedule.label
                        }
                        .tag(Tab.schedule)

                        NavigationLink {
                            gradesView
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
                        gradesView
                    default:
                        scheduleView
                    }
                }
                .accentColor(.main)
            }
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

// MARK: -

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
