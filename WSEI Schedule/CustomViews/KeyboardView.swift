//
//  KeyboardView.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

extension UIKeyboardAppearance {
    static let splitModeHeight: CGFloat = 322
}

private enum KeyboardState {
    case hidden
    case docked
    case undocked
    
    init(keyboardFrame: CGRect, superviewFrame: CGRect) {
        if keyboardFrame.height == 0 {
            self = .hidden
        } else if keyboardFrame.height + keyboardFrame.origin.y == superviewFrame.height {
            self = .docked
        } else  {
            self = .undocked
        }
    }
}

@IBDesignable
class KeyboardView: UIView, KeyboardObserver {
    
    private var heightConstraint: NSLayoutConstraint?
    private var lastState: KeyboardState = .hidden
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    private func setup() {
        registerForKeyboardEvents()
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        backgroundColor = UIColor.clear
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
        guard let superview = superview else { return }
        
        let keyboardState = KeyboardState(keyboardFrame: notification.keyboardFrame, superviewFrame: superview.frame)
        
        var height = notification.keyboardFrame.size.height - superview.safeAreaInsets.bottom
        height = keyboardState == .docked ? height : 0
        heightConstraint?.constant = max(0, height)
        
        guard keyboardState != lastState else { return }
        lastState = keyboardState
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(notification.keyboardAnimationDuration)
        UIView.setAnimationCurve(notification.keyboardAnimationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        superview.layoutIfNeeded()
        UIView.commitAnimations()
    }
}
