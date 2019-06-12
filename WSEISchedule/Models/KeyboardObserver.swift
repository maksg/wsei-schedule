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
    
    init(keyboardFrame: CGRect) {
        if keyboardFrame.height == 0 {
            self = .hidden
        } else if keyboardFrame.height + keyboardFrame.origin.y == UIApplication.shared.keyWindow?.frame.size.height {
            self = .docked
        } else  {
            self = .undocked
        }
    }
}

final class KeyboardObserver: BindableObject, KeyboardObserverProtocol {
    let didChange = PassthroughSubject<KeyboardObserver, Never>()
    
    private var lastState: KeyboardState = .hidden
    var keyboardHeight: CGFloat = 0.0 {
        didSet {
            didChange.send(self)
        }
    }
    var animationDuration: Double = 0.0
    var animationCurve: BasicAnimationTimingCurve = .easeInOut
    
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
        let keyboardState = KeyboardState(keyboardFrame: notification.keyboardFrame)
        
        animationDuration = notification.keyboardAnimationDuration
        animationCurve = notification.keyboardAnimationCurve
        
        let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        var height = notification.keyboardFrame.size.height - safeAreaInsets.bottom
        height = keyboardState == .docked ? height : 0
        keyboardHeight = max(0, height)
        
        guard keyboardState != lastState else { return }
        lastState = keyboardState
    }
    
}
