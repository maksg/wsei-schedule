//
//  WidgetConfiguration+ContentMarginsDisabled.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/02/2025.
//  Copyright © 2025 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension WidgetConfiguration {
    func widgetContentMarginsDisabled() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 15.0, *) {
            return contentMarginsDisabled()
        } else {
            return self
        }
    }
}
