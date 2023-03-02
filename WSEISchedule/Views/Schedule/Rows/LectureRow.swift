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
    @State private var showDetails: Bool = false

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
        "\(lecture.fromDate.voiceOverHour) \(Translation.Accessibility.Schedule.to.localized) \(lecture.toDate.voiceOverHour)"
    }

    // MARK: - Views

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(lecture.subject)
                        .font(.headline)
                        .accessibility(hint: Text(Translation.Accessibility.Schedule.subject.localized))

                    HStack {
                        Image.time
                            .foregroundColor(.red)
                            .accessibilityElement()
                            .accessibility(label: Text(Translation.Accessibility.Schedule.time.localized))
                        Text(time)
                            .accessibility(label: Text(accessibilityTime))

                        Spacer()

                        Image.classroom
                            .foregroundColor(.blue)
                            .accessibilityElement()
                            .accessibility(label: Text(Translation.Accessibility.Schedule.classroom.localized))
                        Text(lecture.classroom)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .heightReader(height: $defaultHeight)

                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundColor(.tertiary)
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Image.code
                            .foregroundColor(.main)
                            .accessibilityElement()
                            .accessibility(label: Text(Translation.Accessibility.Schedule.code.localized))
                        Text(lecture.code)
                    }

                    HStack(alignment: .top) {
                        Image.lecturer
                            .foregroundColor(.orange)
                            .accessibilityElement()
                            .accessibility(label: Text(Translation.Accessibility.Schedule.lecturer.localized))
                        Text(lecture.lecturer)
                    }

                    HStack(alignment: .top) {
                        Image.comments
                            .foregroundColor(.indigo)
                            .accessibilityElement()
                            .accessibility(label: Text(Translation.Accessibility.Schedule.comments.localized))
                        Text(lecture.comments)
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
