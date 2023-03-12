//
//  GradesView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GradesView: View {

    // MARK: - Properties

    @Environment(\.scenePhase) private var scenePhase: ScenePhase

    @AppStorage(UserDefaults.Key.premium.rawValue) private var isPremium: Bool = false
    @ObservedObject var viewModel: GradesViewModel

    private func isExpanded(key: String) -> Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.isExpanded.contains(key) },
            set: { isExpanding in
                if isExpanding {
                    viewModel.isExpanded.insert(key)
                } else {
                    viewModel.isExpanded.remove(key)
                }
            }
        )
    }

    private func isRefreshing(key: String) -> Bool {
        viewModel.isRefreshing.contains(key)
    }

    // MARK: - Views

    var body: some View {
        if isPremium {
            List {
                ScrollToTopView()

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .listRowBackground(Color.red)
                }

                if viewModel.isRefreshingAll {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .id(UUID())
                }

                if viewModel.gradeSemesters.isEmpty {
                    Text(Translation.Grades.noGrades.localized)
                } else {
                    Section {
                        ForEach(viewModel.gradeSemesters) { semester in
                            DisclosureGroup(isExpanded: isExpanded(key: semester.id)) {
                                if semester.grades.isEmpty {
                                    if isRefreshing(key: semester.id) {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .id(UUID())
                                    } else {
                                        Text(Translation.Grades.noGrades.localized)
                                    }
                                } else {
                                    ForEach(semester.grades, content: GradeRow.init)
                                }
                            } label: {
                                HStack {
                                    Text(semester.name)
                                        .foregroundColor(.main)
                                    Spacer()
                                    Text(semester.status.title)
                                        .foregroundColor(semester.status.color)
                                }
                                .font(.headline)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .pullToRefresh(onRefresh: pullToRefresh)
            .navigationTitle(Tab.grades.title)
            .accessibility(identifier: "GradesList")
            .accessibility(hint: Text(Translation.Accessibility.Grades.list.localized))
            .onAppear(perform: reload)
            .onChange(of: scenePhase, perform: onScenePhaseChange)
        } else {
            PremiumView()
        }
    }

    // MARK: - Methods

    private func onScenePhaseChange(_ scenePhase: ScenePhase) async {
        guard scenePhase == .active else { return }
        await reload()
    }

    private func reload() async {
        await viewModel.fetchGradeSemesters()
    }

    private func pullToRefresh() async {
        await viewModel.fetchGradeSemesters(showRefreshControl: false)
    }

}

// MARK: -

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(viewModel: GradesViewModel(apiRequest: APIRequest(), htmlReader: HTMLReader()))
    }
}
