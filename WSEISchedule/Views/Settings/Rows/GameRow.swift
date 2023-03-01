//
//  GameRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GameRow: View {

    // MARK: - Properties

    let game: Games

    // MARK: - Views

    var body: some View {
        Button(action: openGameUrl) {
            HStack {
                Image(game.name)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                Text(game.name)
                    .foregroundColor(.main)
            }
        }
        .frame(height: 30)
    }

    // MARK: - Methods

    private func openGameUrl() {
        UIApplication.shared.open(game.url, options: [:])
    }

}

struct GameRow_Previews: PreviewProvider {
    static var previews: some View {
        GameRow(game: .scareCrows)
    }
}
