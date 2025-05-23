//
//  RootView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct RootView: View {

    // MARK: - Properties

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase: ScenePhase

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

    struct NavigationStackView<Content: View>: View {
        let content: () -> Content

        var body: some View {
            if #available(iOS 16.0, *) {
                return NavigationStack(root: content)
            } else {
                return NavigationView(content: content)
            }
        }
    }

    @available(iOS 16.0, *)
    struct NewNavigationSplitView<A: View, B: View>: View {
        @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
        @ObservedObject var viewModel: RootViewModel
        let scheduleView: A
        let gradesView: B

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
                .navigationTitle(.other(.wseiSchedule))
                .accessibilityIdentifier("Sidebar")
            } detail: {
                switch viewModel.selectedListItem {
                case .grades:
                    gradesView
                default:
                    scheduleView
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
                NavigationStackView {
                    scheduleView
                }
                .tabItem(Tab.schedule.tabItem)
                .tag(Tab.schedule)

                NavigationStackView {
                    gradesView
                }
                .tabItem(Tab.grades.tabItem)
                .tag(Tab.grades)

                NavigationStackView {
                    SettingsView(viewModel: viewModel.settingsViewModel, isSignedIn: $viewModel.isSignedIn)
                }
                .tabItem(Tab.settings.tabItem)
                .tag(Tab.settings)
            }
            .accentColor(.main)
        } else {
            if #available(iOS 16.0, *) {
                NewNavigationSplitView(
                    viewModel: viewModel,
                    scheduleView: NavigationStack(root: { scheduleView }),
                    gradesView: NavigationStack(root: { gradesView })
                )
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
                    .navigationTitle(.other(.wseiSchedule))

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
                #if targetEnvironment(macCatalyst)
                .onAppear(perform: onAppear)
                #endif
                .onChange(of: scenePhase, perform: onScenePhaseChange)
                .onKeyboardShortcut("1", perform: showSchedule)
                .onKeyboardShortcut("2", perform: showGrades)
        } else {
            SignInView(viewModel: viewModel.signInViewModel)
                .transition(.move(edge: .bottom))
        }
    }

    // MARK: - Methods

    private func onAppear() {
        viewModel.reloadData()
    }

    private func onScenePhaseChange(_ scenePhase: ScenePhase) {
        guard scenePhase == .active else { return }
        viewModel.reloadData()
    }

    private func showSchedule() {
        viewModel.selectedListItem = .schedule
    }

    private func showGrades() {
        viewModel.selectedListItem = .grades
    }

}

// MARK: -

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
