//
//  DayHeader.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct DayHeader : View {
    let date: Date
    var formattedDate: String {
        date.isToday ? Translation.Schedule.today.localized : date.formattedDay
    }
    
    var body: some View {
        Text(formattedDate)
            .font(.headline)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

#if DEBUG
struct DayHeader_Previews : PreviewProvider {
    static var previews: some View {
        DayHeader(date: Date())
            .previewLayout(.fixed(width: 320, height: 32))
    }
}
#endif
