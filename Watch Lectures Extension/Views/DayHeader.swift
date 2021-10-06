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

    // MARK: Views
    
    var body: some View {
        Text(date.formattedDay)
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .textCase(.none)
    }

}

struct DayHeader_Previews: PreviewProvider {
    static var previews: some View {
        DayHeader(date: Date())
    }
}
