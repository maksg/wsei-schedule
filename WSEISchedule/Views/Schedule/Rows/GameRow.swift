//
//  GameRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GameRow: View {
    var game: Games
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(self.game.url, options: [:])
        }, label: {
            HStack {
                Image(game.name)
                    .renderingMode(.original)
                    .cornerRadius(10)
                Text(game.name)
                    .foregroundColor(.main)
            }
        })
    }
}

struct GameRow_Previews: PreviewProvider {
    static var previews: some View {
        GameRow(game: .scareCrows)
    }
}
