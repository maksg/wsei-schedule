//
//  View+Keyboard.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {
    
    func enableKeyboard(color: Color = .clear) -> some View {
        KeyboardView(color) {
            self
        }
        .environmentObject(KeyboardObserver())
    }
    
}
