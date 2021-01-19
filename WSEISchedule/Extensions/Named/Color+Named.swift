//
//  Color+Named.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension Color {
    
    static var main: Color {
        Color("Main")
    }

    static var tertiary: Color {
        Color(.tertiaryLabel)
    }

    static var quaternary: Color {
        Color(.quaternaryLabel)
    }

    static var quaternaryBackground: Color {
        Color(.quaternarySystemFill)
    }

    static var background: Color {
        Color(.systemBackground)
    }

    static var indigo: Color {
        Color(.systemIndigo)
    }
    
}
