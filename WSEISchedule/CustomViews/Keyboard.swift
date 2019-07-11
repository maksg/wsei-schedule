//
//  Keyboard.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/07/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct Keyboard : View {
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    var viewFrame: CGRect
    
    var body: some View {
        self.keyboardObserver.viewFrame = viewFrame
        return Rectangle()
            .fill(Color.clear)
            .frame(height: self.keyboardObserver.height)
            .animation(.basic(duration: self.keyboardObserver.animationDuration,
                              curve: self.keyboardObserver.animationCurve))
    }
}

#if DEBUG
struct Keyboard_Previews : PreviewProvider {
    static var previews: some View {
        Keyboard(viewFrame: .zero)
    }
}
#endif
