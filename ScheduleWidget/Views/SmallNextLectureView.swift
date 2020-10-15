//
//  SmallNextLectureView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SmallNextLectureView: View {

    // MARK: Properties

    let lecture: Lecture

    // MARK: Views

    var body: some View {
        LectureView(lecture: lecture, enabledModules: [.date, .time, .classroom], minimumScaleFactor: 0.7)
    }
    
}

struct SmallNextLectureView_Previews: PreviewProvider {
    static var previews: some View {
        SmallNextLectureView(lecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
