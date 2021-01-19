//
//  View+Uncapitalized.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/01/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    @ViewBuilder
    func uncapitalized() -> some View {
        if #available(watchOSApplicationExtension 7.0, *) {
            textCase(.none)
        } else {
            self
        }
    }

}

