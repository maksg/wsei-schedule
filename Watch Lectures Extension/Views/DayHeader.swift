//
//  DayHeader.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
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

    // MARK: Views
    
    var body: some View {
        Text(formattedDate)
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .uncapitalized()
    }

}

struct DayHeader_Previews: PreviewProvider {
    static var previews: some View {
        DayHeader(date: Date())
    }
}
