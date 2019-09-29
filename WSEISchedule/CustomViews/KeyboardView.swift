//
//  KeyboardView.swift
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct KeyboardView<Content>: View where Content: View {
    @EnvironmentObject private var keyboardObserver: KeyboardObserver
    var content: Content
    var color: Color
    
    @inlinable public init(_ color: Color = .clear, content: () -> Content) {
        self.color = color
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.content
                Keyboard(viewFrame: geometry.frame(in: .global), color: self.color)
                    .frame(height: self.keyboardObserver.height)
                    .animation(.easeInOut(duration: self.keyboardObserver.animationDuration))
            }
        }
        .onTapGesture {
            self.keyboardObserver.endEditing()
        }
    }
}

struct KeyboardView_Previews : PreviewProvider {
    static var previews: some View {
        KeyboardView {
            Rectangle()
        }
    }
}
