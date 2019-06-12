//
//  Notification+Keyboard.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit
import SwiftUI

extension Notification {
    
    var keyboardFrame: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
    }
    
    var keyboardAnimationDuration: Double {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
    }
    
    var keyboardAnimationCurve: BasicAnimationTimingCurve {
        let animationCurve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        return BasicAnimationTimingCurve(curve: UIView.AnimationCurve(rawValue: animationCurve))
    }
    
}
