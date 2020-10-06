//
//  UIViewAnimationCurve+Animation.swift
//  Happ
//
//  Created by Maksymilian Galas on 13/09/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import SwiftUI

extension UIView.AnimationCurve {
    func animation(duration: Double) -> Animation {
        switch self {
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .linear:
            return .linear(duration: duration)
        default:
            return .default
        }
    }
}
