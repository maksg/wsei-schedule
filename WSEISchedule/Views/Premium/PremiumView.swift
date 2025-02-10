//
//  PremiumView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 29/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct PremiumView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: PremiumViewModel = PremiumViewModel()

    // MARK: - Views

    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: 40) {
                    Text(.premium(.title))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    PremiumItem(
                        image: .grades,
                        color: .orange,
                        title: .premium(.gradesTitle),
                        content: .premium(.gradesContent)
                    )

                    PremiumItem(
                        image: .scheduleHistory,
                        color: .blue,
                        title: .premium(.scheduleHistoryTitle),
                        content: .premium(.scheduleHistoryContent)
                    )

                    PremiumItem(
                        image: .comingSoon,
                        color: .gray,
                        title: .premium(.comingSoonTitle),
                        content: .premium(.comingSoonContent)
                    )
                }
                .padding(.horizontal, 16)
            }

            Button("\(.premium(.buy)) \(viewModel.price)", action: buyPremium)
                .font(.headline)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.main)
                .cornerRadius(16)
                .foregroundColor(.white)

            Button(action: restorePurchase) {
                Text(.premium(.restore))
                    .foregroundColor(.main)
            }
        }
        .padding(32)
    }

    // MARK: - Methods

    private func buyPremium() {
        viewModel.buyPremium()
    }

    private func restorePurchase() {
        viewModel.restorePurchase()
    }
    
}

// MARK: -

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}
