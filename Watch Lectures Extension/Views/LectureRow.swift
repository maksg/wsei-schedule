//
//  LectureRow.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow : View {
    var lecture: Lecture
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(lecture.subject)
                .font(.headline)
                .lineLimit(nil)
            HStack(spacing: 0) {
                Text(lecture.fromDate.shortHour)
                Text("-")
                Text(lecture.toDate.shortHour)
                Spacer()
                Text(lecture.classroom)
            }
        }
        .font(.footnote)
        .padding(.horizontal, 0)
        .padding(.vertical, 4)
    }
}

struct LectureRow_Previews : PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockData.lecture)
    }
}
