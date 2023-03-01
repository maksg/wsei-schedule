//
//  AnimatableRowHeight.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/01/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct AnimatableRowHeight: AnimatableModifier {

    // MARK: - Properties

    var height: CGFloat = 0

    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    // MARK: - Views

    func body(content: Content) -> some View {
        content.frame(height: height, alignment: .top).clipped()
    }
    
}

extension View {

    func animatableRowHeight(_ height: CGFloat) -> some View {
        modifier(AnimatableRowHeight(height: height))
    }

}
