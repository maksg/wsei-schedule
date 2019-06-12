//
//  BasicAnimationTimingCurve+UIViewAnimationCurve.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension BasicAnimationTimingCurve {
    
    init(curve: UIView.AnimationCurve?) {
        switch curve {
        case .easeIn:
            self = .easeIn
        case .easeOut:
            self = .easeOut
        case .linear:
            self = .linear
        default:
            self = .easeInOut
        }
    }
    
}
