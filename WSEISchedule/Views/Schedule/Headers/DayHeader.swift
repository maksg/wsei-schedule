//
//  DayHeader.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct DayHeader: View {

    // MARK: - Properties

    let date: Date

    // MARK: - Views
    
    var body: some View {
        Text(date.formattedDay)
            .font(.headline)
            .foregroundColor(.main)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .textCase(.none)
            .accessibilityLabel(Text(date.voiceOverDay))
    }
}

struct DayHeader_Previews: PreviewProvider {
    static var previews: some View {
        DayHeader(date: Date())
            .previewLayout(.fixed(width: 320, height: 32))
    }
}
