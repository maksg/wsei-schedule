//
//  PremiumView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 29/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct PremiumView: View {

    // MARK: Properties

    @AppStorage(UserDefaults.Key.premium.rawValue) var isPremium: Bool = false

    // MARK: Views

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 40) {
                    Text(Translation.Premium.title.localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    PremiumItem(
                        image: .grades,
                        color: .orange,
                        title: Translation.Premium.Grades.title.localized,
                        content: Translation.Premium.Grades.content.localized
                    )

                    PremiumItem(
                        image: .scheduleHistory,
                        color: .blue,
                        title: Translation.Premium.ScheduleHistory.title.localized,
                        content: Translation.Premium.ScheduleHistory.content.localized
                    )

                    PremiumItem(
                        image: .comingSoon,
                        color: .gray,
                        title: Translation.Premium.ComingSoon.title.localized,
                        content: Translation.Premium.ComingSoon.content.localized
                    )
                }
                .padding(.horizontal, 16)
            }

            Button("\(Translation.Premium.button.localized) $4.99", action: buyPremium)
                .font(.headline)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.main)
                .cornerRadius(17)
                .foregroundColor(.white)
        }
        .padding(32)
    }

    // MARK: Methods

    private func buyPremium() {
        isPremium = true
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}
