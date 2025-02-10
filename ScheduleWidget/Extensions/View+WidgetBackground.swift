//
//  View+WidgetBackground.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/02/2025.
//  Copyright © 2025 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
