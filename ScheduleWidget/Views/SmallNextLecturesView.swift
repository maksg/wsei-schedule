//
//  SmallNextLecturesView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SmallNextLecturesView: View {

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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()
                Text(formattedDate)
                    .fontWeight(.semibold)
            }

            Text(lecture.subject)
                .font(.headline)
                .minimumScaleFactor(0.7)
                .foregroundColor(.main)
                .lineLimit(nil)

            Spacer()

            HStack(spacing: 4) {
                Image.time.foregroundColor(.main)
                HStack(spacing: 1) {
                    Text(lecture.fromDate.shortHour)
                    Text("-")
                    Text(lecture.toDate.shortHour)
                }
            }

            HStack(spacing: 4) {
                Image.classroom.foregroundColor(.main)
                Text(lecture.classroom)
            }
        }
        .lineLimit(1)
        .font(.footnote)
        .padding()
    }
    
}

struct SmallNextLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        SmallNextLecturesView(lecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
