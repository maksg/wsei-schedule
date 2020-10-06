//
//  InsetGroupedListStyle.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 23/06/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func insetGroupedListStyle() -> some View {
        if #available(iOS 14.0, *) {
            listStyle(InsetGroupedListStyle())
        } else {
            listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
        }
    }
    
}
