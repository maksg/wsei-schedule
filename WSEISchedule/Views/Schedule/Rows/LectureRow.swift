//
//  LectureRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow: View {
    var lecture: LectureProtocol
    @State private var hideDetails: Bool = true
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                self.hideDetails.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: 7) {
                Text(lecture.subject)
                    .font(.headline)
                    .lineLimit(nil)
                HStack(spacing: 1) {
                    Text("\(lecture.fromDate.shortHour)")
                    Text("-")
                    Text("\(lecture.toDate.shortHour)")
                    Spacer()
                    Text(lecture.classroom)
                }
                if !hideDetails {
                    HStack {
                        Text(lecture.lecturer)
                        Spacer()
                        Text(lecture.code)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
            .font(.footnote)
            .padding(4)
        }
    }
}

struct LectureRow_Previews : PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: CodableLecture(lecturer: "Lecturer", classroom: "Classroom", fromDate: Date(), toDate: Date(), code: "Code", subject: "Subject"))
            .previewLayout(.fixed(width: 320, height: 75))
    }
}
