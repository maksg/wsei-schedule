//
//  KeyboardAdaptive.swift
//
//  Created by Maksymilian Galas on 13/09/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, bottomPadding)
                .onReceive(Publishers.keyboardInfo) { onReceiveKeyboardInfo($0, geometry: geometry) }
        }
    }

    private func onReceiveKeyboardInfo(_ keyboardInfo: KeyboardInfo, geometry: GeometryProxy) {
        let viewFrame = geometry.frame(in: .global)
        let bottomY = UIScreen.main.bounds.height - viewFrame.origin.y - viewFrame.height
        withAnimation(keyboardInfo.animation) {
            bottomPadding = max(0, keyboardInfo.height - bottomY)
        }
    }
}

extension View {
    @ViewBuilder
    func keyboardAdaptive() -> some View {
        if #available(iOS 14, *) {
            self
        } else {
            ModifiedContent(content: self, modifier: KeyboardAdaptive())
        }
    }
}
