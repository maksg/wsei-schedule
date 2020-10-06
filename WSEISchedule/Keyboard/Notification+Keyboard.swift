//
//  Notification+Keyboard.swift
//
//  Created by Maksymilian Galas on 13/09/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import SwiftUI

extension Notification {

    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0.0
    }

    var keyboardAnimationDuration: Double {
        (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.0
    }

    var keyboardAnimation: Animation {
        let animationCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int) ?? 0
        return UIView.AnimationCurve(rawValue: animationCurve)?.animation(duration: keyboardAnimationDuration) ?? .default
    }

}
