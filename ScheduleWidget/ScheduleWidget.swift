//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Maksymilian Galas on 09/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WSEI Schedule")
        .description(Translation.Widget.about.localized)
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
