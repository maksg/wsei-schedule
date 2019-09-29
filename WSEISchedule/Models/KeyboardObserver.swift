//
//  KeyboardObserver.swift
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI

private enum KeyboardState {
    case hidden
    case docked
    case undocked
    
    init(keyboardFrame: CGRect, windowHeight: CGFloat) {
        if keyboardFrame.height == 0 {
            self = .hidden
        } else if keyboardFrame.height + keyboardFrame.origin.y == windowHeight {
            self = .docked
        } else  {
            self = .undocked
        }
    }
}

final class KeyboardObserver: ObservableObject, KeyboardObservable {
    private static var window: UIWindow!
    private var lastState: KeyboardState = .hidden
    
    var viewFrame: CGRect = .zero {
        willSet {
            if viewFrame != newValue {
                objectWillChange.send()
            }
        }
    }
    
    @Published private var keyboardHeight: CGFloat = 0.0
    
    var height: CGFloat {
        let height = keyboardHeight - (KeyboardObserver.window.frame.size.height - viewFrame.size.height - viewFrame.origin.y)
        return max(0, height)
    }
    
    var animationDuration: Double = 0.0
    
    convenience init(window: UIWindow) {
        KeyboardObserver.window = window
        self.init()
    }
    
    init() {
        registerForKeyboardEvents()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    private func layoutKeyboard(for notification: Notification) {
        let keyboardState = KeyboardState(keyboardFrame: notification.keyboardFrame, windowHeight: KeyboardObserver.window.frame.size.height)
        
        animationDuration = notification.keyboardAnimationDuration
        
        var height = notification.keyboardFrame.size.height
        height = keyboardState == .docked ? height : 0
        keyboardHeight = max(0, height)
        
        guard keyboardState != lastState else { return }
        lastState = keyboardState
    }
    
    func endEditing() {
        KeyboardObserver.window.endEditing(true)
    }
    
}
