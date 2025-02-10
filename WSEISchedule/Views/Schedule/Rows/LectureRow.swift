//
//  LectureRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow: View {

    // MARK: - Properties

    let lecture: Lecture
    @State private var showDetails: Bool

    @State private var expandedHeight: CGFloat = .zero
    @State private var defaultHeight: CGFloat = .zero

    private let verticalPadding: CGFloat = 8.0

    private var rowHeight: CGFloat {
        if showDetails {
            return expandedHeight
        } else {
            return defaultHeight + verticalPadding * 2
        }
    }

    private var time: String {
        "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour)"
    }

    private var accessibilityTime: String {
        "\(lecture.fromDate.voiceOverHour) \(String.accessibility(.scheduleTo)) \(lecture.toDate.voiceOverHour)"
    }

    // MARK: - Initialization

    init(lecture: Lecture) {
        self.init(lecture: lecture, showDetails: false)
    }

    init(lecture: Lecture, showDetails: Bool = false) {
        self.lecture = lecture
        self._showDetails = State(initialValue: showDetails)
    }

    // MARK: - Views

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(lecture.subject)
                        .font(.headline)
                        .accessibilityHint(Text(.accessibility(.scheduleSubject)))

                    HStack {
                        Image.time
                            .foregroundColor(.red)
                            .accessibilityElement()
                            .accessibilityLabel(Text(.accessibility(.scheduleTime)))
                        Text(time)
                            .accessibilityLabel(Text(accessibilityTime))

                        Spacer()

                        Image.classroom
                            .foregroundColor(.blue)
                            .accessibilityElement()
                            .accessibilityLabel(Text(.accessibility(.scheduleClassroom)))
                        Text(lecture.classroom)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .heightReader(height: $defaultHeight)

                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundColor(.quaternary)
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Image.code
                            .foregroundColor(.main)
                            .accessibilityElement()
                            .accessibilityLabel(Text(.accessibility(.scheduleCode)))
                        Text(lecture.code)
                    }

                    HStack(alignment: .top) {
                        Image.lecturer
                            .foregroundColor(.orange)
                            .accessibilityElement()
                            .accessibilityLabel(Text(.accessibility(.scheduleLecturer)))
                        Text(lecture.lecturer)
                    }

                    if !lecture.comments.isEmpty {
                        HStack(alignment: .top) {
                            Image.comments
                                .foregroundColor(.indigo)
                                .accessibilityElement()
                                .accessibilityLabel(Text(.accessibility(.scheduleComments)))
                            Text(lecture.comments)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundColor(.primary)
            .font(.footnote)
            .padding(.vertical, verticalPadding)
        }
        .heightReader(height: $expandedHeight)
        .animatableRowHeight(rowHeight)
    }

    // MARK: - Methods

    private func onTap() {
        withAnimation(.easeInOut(duration: 0.1)) {
            showDetails.toggle()
        }
    }

}

// MARK: -

struct LectureRow_Previews: PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockData.lecture)
            .previewLayout(.fixed(width: 320, height: 75))
    }
}
