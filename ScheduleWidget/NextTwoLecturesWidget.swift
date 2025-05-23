//
//  NextTwoLecturesWidget.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NextTwoLecturesWidget: Widget {
    let kind: String = "NextTwoLecturesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NextTwoLecturesWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight:  .infinity)
                .widgetBackground(Color("WidgetBackground"))
        }
        .configurationDisplayName(String.other(.wseiSchedule))
        .description(String.widget(.aboutNextTwoLectures))
        .supportedFamilies([.systemLarge])
        .widgetContentMarginsDisabled()
    }
}
