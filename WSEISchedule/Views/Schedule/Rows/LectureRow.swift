//
//  LectureRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow: View {
    let lecture: LectureProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(lecture.subject)
                .font(.headline)
                .lineLimit(nil)
            HStack {
                Text("\(lecture.fromDate.shortHour) - \(lecture.toDate.shortHour)")
                Spacer()
                Text(lecture.classroom)
            }
            HStack {
                Text(lecture.lecturer)
                Spacer()
                Text(lecture.code)
            }
            .foregroundColor(.secondary)
        }
        .font(.footnote)
        .padding(6)
    }
}

#if DEBUG
struct LectureRow_Previews : PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockLecture(lecturer: "Lecturer", classroom: "Classroom", fromDate: Date(), toDate: Date(), code: "Code", subject: "Subject"))
            .previewLayout(.fixed(width: 320, height: 90))
    }
}
#endif
