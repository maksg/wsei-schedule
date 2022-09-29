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
    @ObservedObject private var viewModel: PremiumViewModel = PremiumViewModel()

    // MARK: Views

    var body: some View {
        VStack(spacing: 16) {
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

            Button("\(Translation.Premium.buy.localized) \(viewModel.price)", action: buyPremium)
                .font(.headline)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.main)
                .cornerRadius(16)
                .foregroundColor(.white)

            Button(action: restorePurchase) {
                Text(Translation.Premium.restore.localized)
                    .foregroundColor(.main)
            }
        }
        .padding(32)
    }

    // MARK: Methods

    private func buyPremium() {
        viewModel.buyPremium()
    }

    private func restorePurchase() {
        viewModel.restorePurchase()
    }
    
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}
