//
//  Notification+Keyboard.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

extension Notification {
    
    var keyboardFrame: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
    }
    
    var keyboardAnimationDuration: Double {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
    }
    
    var keyboardAnimationCurve: UIView.AnimationCurve {
        let animationCurve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        return UIView.AnimationCurve(rawValue: animationCurve) ?? UIView.AnimationCurve.easeInOut
    }
    
}
