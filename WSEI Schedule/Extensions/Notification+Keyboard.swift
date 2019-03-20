//
//  Notification+Keyboard.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

extension Notification {
    
    var keyboardSize: CGSize {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size ?? CGSize.zero
    }
    
    var keyboardAnimationDuration: Double {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
    }
    
    var keyboardAnimationCurve: UIView.AnimationOptions {
        let animationOptions = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        return UIView.AnimationOptions(rawValue: animationOptions)
    }
    
}
