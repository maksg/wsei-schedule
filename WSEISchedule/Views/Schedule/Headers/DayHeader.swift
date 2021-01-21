//
//  DayHeader.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct DayHeader: View {

    // MARK: Properties

    let date: Date
    var formattedDate: String {
        if date.isToday {
            return Translation.Schedule.today.localized
        } else if date.isTomorrow {
            return Translation.Schedule.tomorrow.localized
        } else {
            return date.formattedDay
        }
    }

    var voiceOverDate: String {
        if date.isToday {
            return Translation.Schedule.today.localized
        } else if date.isTomorrow {
            return Translation.Schedule.tomorrow.localized
        } else {
            return date.voiceOverDay
        }
    }

    // MARK: Views
    
    var body: some View {
        Text(formattedDate)
            .font(.headline)
            .foregroundColor(.main)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .uncapitalized()
            .accessibility(label: Text(voiceOverDate))
    }
}

struct DayHeader_Previews: PreviewProvider {
    static var previews: some View {
        DayHeader(date: Date())
            .previewLayout(.fixed(width: 320, height: 32))
    }
}
