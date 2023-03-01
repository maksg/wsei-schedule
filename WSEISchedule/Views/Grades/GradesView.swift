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

    @AppStorage(UserDefaults.Key.premium.rawValue) var isPremium: Bool = false
    @ObservedObject var viewModel: GradesViewModel

    // MARK: - Views

    var body: some View {
        if isPremium {
            List {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .listRowBackground(Color.red)
                }

                ForEach(viewModel.grades, content: GradeRow.init)
            }
            .listStyle(.insetGrouped)
            .pullToRefresh(onRefresh: reload, isRefreshing: $viewModel.isRefreshing)
            .navigationTitle(Tab.grades.title)
            .accessibility(identifier: "GradesList")
            .accessibility(hint: Text(Translation.Accessibility.Grades.list.localized))
            .onAppear(perform: reload)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: onWillEnterForeground)
        } else {
            PremiumView()
                .navigationBarHidden(true)
        }
    }

    // MARK: - Methods

    private func onWillEnterForeground(_ output: NotificationCenter.Publisher.Output) {
        reload()
    }

    private func reload() {
        viewModel.reloadGrades()
    }

}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView(viewModel: GradesViewModel(apiRequest: APIRequest(), captchaReader: CaptchaReader(), htmlReader: HTMLReader()))
    }
}
