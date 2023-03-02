//
//  PremiumItem.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 29/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct PremiumItem: View {

    // MARK: - Properties

    let image: Image
    let color: Color
    let title: String
    let content: String

    // MARK: - Views

    var body: some View {
        HStack(spacing: 0) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(color)

            Spacer().frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(content)
            }

            Spacer()
        }
    }

}

// MARK: -

struct PremiumItem_Previews: PreviewProvider {
    static var previews: some View {
        PremiumItem(image: .comingSoon, color: .orange, title: "Title", content: "Content")
    }
}
