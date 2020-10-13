//
//  LargeNextLecturesView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LargeNextLecturesView: View {

    // MARK: Properties

    let lecture: Lecture

    private var formattedDate: String {
        let date = lecture.fromDate
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Text(formattedDate)
                    .fontWeight(.semibold)
            }
            .lineLimit(1)

            Text(lecture.subject)
                .font(.headline)
                .minimumScaleFactor(0.9)
                .foregroundColor(.main)

            Spacer()

            HStack {
                Image.time.foregroundColor(.main)
                HStack(spacing: 1) {
                    Text(lecture.fromDate.shortHour)
                    Text("-")
                    Text(lecture.toDate.shortHour)
                }
            }

            HStack {
                Image.classroom.foregroundColor(.main)
                Text(lecture.classroom)
            }

            HStack(alignment: .top) {
                Image.code.foregroundColor(.main)
                Text(lecture.code)
            }

            HStack(alignment: .top) {
                Image.lecturer.foregroundColor(.main)
                Text(lecture.lecturer)
            }

            HStack(alignment: .top) {
                Image.comments.foregroundColor(.main)
                Text(lecture.comments)
            }
        }
        .font(.footnote)
        .padding()
    }

}

struct LargeNextLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LargeNextLecturesView(lecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
