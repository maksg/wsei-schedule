//
//  View+Uncapitalized.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    @ViewBuilder func uncapitalized() -> some View {
        if #available(iOS 14, *) {
            textCase(.none)
        } else {
            self
        }
    }

}
