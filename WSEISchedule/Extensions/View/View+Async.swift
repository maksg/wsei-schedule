//
//  View+Async.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 02/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    func onKeyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command, perform action: @escaping () async -> Void) -> some View {
        onKeyboardShortcut(key, modifiers: modifiers) {
            Task {
                await action()
            }
        }
    }

}
