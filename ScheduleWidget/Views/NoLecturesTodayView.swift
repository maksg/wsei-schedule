//
//  NoLecturesTodayView.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct NoLecturesTodayView: View {

    // MARK: - Views

    var body: some View {
        VStack(spacing: 10) {
            Text("😎")
                .font(.largeTitle)
            Text(Translation.Widget.noLecturesToday.localized)
        }
    }
}

struct NoLecturesTodayView_Previews: PreviewProvider {
    static var previews: some View {
        NoLecturesTodayView()
    }
}
