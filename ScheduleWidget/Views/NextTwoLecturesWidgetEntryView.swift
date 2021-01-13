//
//  NextTwoLecturesWidgetEntryView.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct NextTwoLecturesWidgetEntryView: View {

    // MARK: Properties

    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry
    var todaysLecture: Lecture? { entry.todaysLecture }
    var nextLecture: Lecture? { entry.nextLecture }

    // MARK: Views

    var body: some View {
        if todaysLecture == nil && nextLecture == nil {
            NoNextLecturesView()
        } else {
            LargeNextTwoLecturesView(todaysLecture: todaysLecture, nextLecture: nextLecture)
        }
    }

}

struct NextTwoLecturesWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextTwoLecturesWidgetEntryView(entry: LectureEntry(date: Date(), todaysLecture: MockData.lecture, nextLecture: MockData.lecture))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
