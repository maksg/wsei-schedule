//
//  MediumNextLecturesView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MediumNextLecturesView: View {

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
                    .foregroundColor(.main)
            }

            Text(lecture.subject)
                .font(.headline)
                .minimumScaleFactor(0.9)
                .lineLimit(nil)

            Spacer()
            
            HStack {
                Image.time.foregroundColor(.red)
                HStack(spacing: 1) {
                    Text(lecture.fromDate.shortHour)
                    Text("-")
                    Text(lecture.toDate.shortHour)
                }
                Spacer()
                Image.classroom.foregroundColor(.blue)
                Text(lecture.classroom)
            }

            HStack(alignment: .top) {
                Image.code.foregroundColor(.main)
                Text(lecture.code)
                    .lineLimit(nil)
            }
        }
        .lineLimit(1)
        .font(.footnote)
        .padding()
    }

}

struct MediumNextLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        MediumNextLecturesView(lecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
