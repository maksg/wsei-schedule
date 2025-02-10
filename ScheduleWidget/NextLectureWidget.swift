//
//  NextLectureWidget.swift
//  ScheduleWidget
//
//  Created by Maksymilian Galas on 09/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NextLectureWidget: Widget {
    let kind: String = "NextLectureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NextLectureWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight:  .infinity)
                .widgetBackground(Color("WidgetBackground"))
        }
        .configurationDisplayName(String.other(.wseiSchedule))
        .description(String.widget(.aboutNextLecture))
        .supportedFamilies([.systemSmall, .systemMedium])
        .widgetContentMarginsDisabled()
    }
}
