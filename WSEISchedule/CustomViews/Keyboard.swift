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
        keyboardObserver.viewFrame = viewFrame
        return Rectangle()
            .fill(color)
            .frame(height: keyboardObserver.height)
            .animation(.easeInOut(duration: keyboardObserver.animationDuration))
    }
}

struct Keyboard_Previews : PreviewProvider {
    static var previews: some View {
        Keyboard(viewFrame: .zero)
            .environmentObject(KeyboardObserver(window: UIApplication.shared.windows.first!))
    }
}
