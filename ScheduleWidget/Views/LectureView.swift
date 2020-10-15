//
//  LectureView.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureView: View {

    enum Module {
        case date
        case time
        case classroom
        case timeAndClassroom
        case code
        case lecturer
        case comments
    }

    // MARK: Properties

    let lecture: Lecture
    let enabledModules: Set<Module>
    let minimumScaleFactor: CGFloat

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

    // MARK: Initialization

    init(lecture: Lecture, enabledModules: Set<LectureView.Module>, minimumScaleFactor: CGFloat = 1.0) {
        self.lecture = lecture
        self.enabledModules = enabledModules
        self.minimumScaleFactor = minimumScaleFactor
    }

    // MARK: Views

    var timeView: some View {
        HStack {
            Image.time.foregroundColor(.red)
            HStack(spacing: 1) {
                Text(lecture.fromDate.shortHour)
                Text("-")
                Text(lecture.toDate.shortHour)
            }
        }
        .lineLimit(1)
    }

    var classroomView: some View {
        HStack {
            Image.classroom.foregroundColor(.blue)
            Text(lecture.classroom)
        }
        .lineLimit(1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if enabledModules.contains(.date) {
                HStack {
                    Spacer()
                    Text(formattedDate)
                        .fontWeight(.semibold)
                        .foregroundColor(.main)
                        .lineLimit(1)
                }
            }

            Text(lecture.subject)
                .font(.headline)
                .minimumScaleFactor(minimumScaleFactor)

            Spacer()

            if enabledModules.contains(.time) {
                timeView
            }

            if enabledModules.contains(.classroom) {
                classroomView
            }

            if enabledModules.contains(.timeAndClassroom) {
                HStack {
                    timeView
                    Spacer()
                    classroomView
                }
            }

            if enabledModules.contains(.code) {
                HStack(alignment: .top) {
                    Image.code.foregroundColor(.main)
                    Text(lecture.code)
                }
            }

            if enabledModules.contains(.lecturer) {
                HStack(alignment: .top) {
                    Image.lecturer.foregroundColor(.orange)
                    Text(lecture.lecturer)
                }
            }

            if enabledModules.contains(.comments) {
                HStack(alignment: .top) {
                    Image.comments.foregroundColor(.indigo)
                    Text(lecture.comments)
                }
            }
        }
        .font(.footnote)
        .padding()
    }
}

struct LectureView_Previews: PreviewProvider {
    static var previews: some View {
        LectureView(lecture: MockData.lecture, enabledModules: [.date, .time, .classroom, .code, .lecturer, .comments])
    }
}
