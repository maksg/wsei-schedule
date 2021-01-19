//
//  LectureRow.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
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
            VStack(alignment: .leading, spacing: 3) {
                Text(lecture.subject)
                    .font(.headline)
                    .lineLimit(nil)

                if hideDetails {
                    HStack(spacing: 0) {
                        Text(lecture.fromDate.shortHour)
                        Text("-")
                        Text(lecture.toDate.shortHour)
                        Spacer()
                        Text(lecture.classroom)
                    }
                } else {
                    HStack(alignment: .top) {
                        Image.time
                        HStack(spacing: 0) {
                            Text(lecture.fromDate.shortHour)
                            Text("-")
                            Text(lecture.toDate.shortHour)
                        }
                    }
                    HStack(alignment: .top) {
                        Image.classroom
                        Text(lecture.classroom)
                    }
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
            .font(.footnote)
            .padding(.horizontal, 0)
            .padding(.vertical, 4)
        }
    }

    // MARK: Methods

    private func onTap() {
        withAnimation {
            hideDetails.toggle()
        }
    }
    
}

struct LectureRow_Previews: PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockData.lecture)
    }
}
