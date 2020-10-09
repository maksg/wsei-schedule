//
//  Line.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
