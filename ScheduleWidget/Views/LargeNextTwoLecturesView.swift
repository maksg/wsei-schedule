//
//  LargeNextTwoLecturesView.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LargeNextTwoLecturesView: View {

    // MARK: - Properties

    let todaysLecture: Lecture?
    let nextLecture: Lecture?

    private var formattedDate: String {
        nextLecture?.fromDate.formattedDay ?? ""
    }

    // MARK: - Views

    var body: some View {
        VStack(spacing: 0) {
            if let todaysLecture = todaysLecture {
                Spacer()
                LectureView(lecture: todaysLecture, enabledModules: [.timeAndClassroom, .code, .lecturer, .comments])
                    .layoutPriority(1)
                Spacer()
            } else {
                NoLecturesTodayView()
                    .padding()
            }

            Divider()

            if let nextLecture = nextLecture {
                if todaysLecture == nil {
                    LectureView(lecture: nextLecture, enabledModules: [.date, .timeAndClassroom, .code, .lecturer, .comments])
                } else {
                    LectureView(lecture: nextLecture, enabledModules: [.date, .timeAndClassroom])
                }
            } else {
                NoNextLecturesView()
                    .padding()
            }
        }
    }
}

struct NextTwoLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        LargeNextTwoLecturesView(todaysLecture: MockData.lecture, nextLecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
