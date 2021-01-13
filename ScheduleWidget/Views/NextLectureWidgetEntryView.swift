//
//  NextLectureWidgetEntryView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct NextLectureWidgetEntryView: View {

    // MARK: Properties

    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry
    var lecture: Lecture? { entry.todaysLecture ?? entry.nextLecture }

    // MARK: Views

    var body: some View {
        if let lecture = lecture {
            switch family {
            case .systemMedium:
                MediumNextLectureView(lecture: lecture)
            default:
                SmallNextLectureView(lecture: lecture)
            }
        } else {
            NoNextLecturesView()
        }
    }
    
}

struct NextLectureWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextLectureWidgetEntryView(entry: LectureEntry(date: Date(), todaysLecture: MockData.lecture, nextLecture: MockData.lecture))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
