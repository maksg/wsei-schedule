//
//  UIApplication+ForegroundActiveScene.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import UIKit

extension UIApplication {

    var foregroundActiveScene: UIWindowScene? {
        connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }

}
