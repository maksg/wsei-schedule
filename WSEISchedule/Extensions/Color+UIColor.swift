//
//  Color+UIColor.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/05/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
}

extension Color {
    
    init(uiColor: UIColor) {
        self.init(red: Double(uiColor.rgba.red),
                  green: Double(uiColor.rgba.green),
                  blue: Double(uiColor.rgba.blue),
                  opacity: Double(uiColor.rgba.alpha))
    }
    
    static var tertiary: Color {
        Color(uiColor: .tertiaryLabel)
    }
    
    static var quaternary: Color {
        Color(uiColor: .quaternaryLabel)
    }
    
    static var groupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }
    
    static var background: Color {
        Color(uiColor: .systemBackground)
    }
    
}
