//
//  View+Keyboard.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {
    
    func keyboard(color: Color = .clear, keyboardObserver: KeyboardObserver = KeyboardObserver()) -> some View {
        KeyboardView(color: color) {
            self
        }
        .environmentObject(keyboardObserver)
    }
    
}
