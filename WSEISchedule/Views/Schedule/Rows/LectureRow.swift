//
//  LectureRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow: View {

    // MARK: Properties

    var lecture: Lecture
    @State private var hideDetails: Bool = true

    // MARK: Views

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(lecture.subject)
                        .font(.headline)
                    HStack {
                        Image.time
                        HStack(spacing: 1) {
                            Text(lecture.fromDate.shortHour)
                            Text("-")
                            Text(lecture.toDate.shortHour)
                        }
                        Spacer()
                        Image.classroom
                        Text(lecture.classroom)
                    }
                }

                if !hideDetails {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundColor(.tertiary)
                        .frame(height: 1)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image.code
                            Text(lecture.code)
                        }

                        HStack(alignment: .top) {
                            Image.lecturer
                            Text(lecture.lecturer)
                        }

                        HStack(alignment: .top) {
                            Image.comments
                            Text(lecture.comments)
                        }
                    }
                }
            }
            .foregroundColor(.primary)
            .font(.footnote)
            .padding(.vertical, 8)
        }
    }

    // MARK: Methods

    private func onTap() {
        withAnimation(.easeInOut) {
            hideDetails.toggle()
        }
    }

}

struct LectureRow_Previews : PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockData.lecture)
            .previewLayout(.fixed(width: 320, height: 75))
    }
}
