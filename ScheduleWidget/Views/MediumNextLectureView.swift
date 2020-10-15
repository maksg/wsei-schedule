//
//  MediumNextLectureView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MediumNextLectureView: View {

    // MARK: Properties

    let lecture: Lecture

    // MARK: Views

    var body: some View {
        LectureView(lecture: lecture, enabledModules: [.date, .timeAndClassroom, .code], minimumScaleFactor: 0.9)
    }

}

struct MediumNextLectureView_Previews: PreviewProvider {
    static var previews: some View {
        MediumNextLectureView(lecture: MockData.lecture)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
