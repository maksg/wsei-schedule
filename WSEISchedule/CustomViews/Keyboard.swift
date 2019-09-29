//
//  Keyboard.swift
//
//  Created by Maksymilian Galas on 11/07/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct Keyboard : View {
    @EnvironmentObject private var keyboardObserver: KeyboardObserver
    var viewFrame: CGRect
    var color: Color = .clear
    
    var body: some View {
        self.keyboardObserver.viewFrame = viewFrame
        return Rectangle()
            .fill(color)
            .frame(height: self.keyboardObserver.height)
            .animation(.easeInOut(duration: self.keyboardObserver.animationDuration))
    }
}

struct Keyboard_Previews : PreviewProvider {
    static var previews: some View {
        Keyboard(viewFrame: .zero)
    }
}
