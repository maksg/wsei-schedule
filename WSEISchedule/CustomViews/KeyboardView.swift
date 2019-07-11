//
//  KeyboardView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct KeyboardView<Content>: View where Content: View {
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    var content: Content
    
    @inlinable public init(content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.content
                Keyboard(viewFrame: geometry.frame(in: .global))
                    .frame(height: self.keyboardObserver.height)
                    .animation(.basic(duration: self.keyboardObserver.animationDuration,
                                      curve: self.keyboardObserver.animationCurve))
            }
        }
        .tapAction {
            self.keyboardObserver.endEditing()
        }
    }
}

#if DEBUG
struct KeyboardView_Previews : PreviewProvider {
    static var previews: some View {
        KeyboardView {
            Rectangle()
        }
    }
}
#endif
