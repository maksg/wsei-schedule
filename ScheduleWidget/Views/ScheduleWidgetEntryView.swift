//
//  ScheduleWidgetEntryView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleWidgetEntryView: View {

    // MARK: Properties

    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry
    var lecture: Lecture? { entry.lecture }

    // MARK: Views

    var body: some View {
        if let lecture = lecture {
            switch family {
            case .systemMedium:
                MediumNextLecturesView(lecture: lecture)
            case .systemLarge:
                LargeNextLecturesView(lecture: lecture)
            default:
                SmallNextLecturesView(lecture: lecture)
            }
        } else {
            NoNextLecturesView()
        }
    }
    
}

struct ScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWidgetEntryView(entry: SimpleEntry(date: Date(), lecture: MockData.lecture))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
