//
//  LectureEntry.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import WidgetKit

struct LectureEntry: TimelineEntry {
    let date: Date
    let todaysLecture: Lecture?
    let nextLecture: Lecture?
}
