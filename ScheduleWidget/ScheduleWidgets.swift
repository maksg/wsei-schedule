//
//  ScheduleWidgets.swift
//  ScheduleWidgetExtension
//
//  Created by Maksymilian Galas on 15/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import WidgetKit

@main
struct ScheduleWidgets: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        NextLectureWidget()
        NextTwoLecturesWidget()
    }

}
