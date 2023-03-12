//
//  View+KeyboardShortcut.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    func onKeyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command, perform action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: .keyboardShortcut)) { notification in
            let shortcut = notification.object as? KeyboardShortcut
            if #available(iOS 15.0, *) {
                guard shortcut == KeyboardShortcut(key, modifiers: modifiers) else { return }
            } else {
                guard shortcut?.key.character == key.character && shortcut?.modifiers == modifiers else { return }
            }
            action()
        }
    }

}

