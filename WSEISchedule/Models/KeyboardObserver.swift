//
//  KeyboardObserver.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation
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

final class KeyboardObserver: BindableObject, KeyboardObservable {
    let didChange = PassthroughSubject<KeyboardObserver, Never>()
    
    private let window: UIWindow
    private var lastState: KeyboardState = .hidden
    
    var viewFrame: CGRect = .zero {
        didSet {
            if viewFrame != oldValue {
                didChange.send(self)
            }
        }
    }
    
    private var keyboardHeight: CGFloat = 0.0 {
        didSet {
            didChange.send(self)
        }
    }
    
    var height: CGFloat {
        let height = keyboardHeight - (window.frame.size.height - viewFrame.size.height - viewFrame.origin.y)
        return max(0, height)
    }
    
    var animationDuration: Double = 0.0
    var animationCurve: BasicAnimationTimingCurve = .easeInOut
    
    init(window: UIWindow) {
        self.window = window
        registerForKeyboardEvents()
    }
    
    func keyboardDidShow(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        layoutKeyboard(for: notification)
    }
    
    private func layoutKeyboard(for notification: Notification) {
        let keyboardState = KeyboardState(keyboardFrame: notification.keyboardFrame, windowHeight: window.frame.size.height)
        
        animationDuration = notification.keyboardAnimationDuration
        animationCurve = notification.keyboardAnimationCurve
        
        var height = notification.keyboardFrame.size.height
        height = keyboardState == .docked ? height : 0
        keyboardHeight = max(0, height)
        
        guard keyboardState != lastState else { return }
        lastState = keyboardState
    }
    
    func endEditing() {
        window.endEditing(true)
    }
    
}
