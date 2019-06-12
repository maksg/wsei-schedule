//
//  KeyboardView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var keyboardObserver: KeyboardObserver

    var body: some View {
        Rectangle()
            .animation(.basic(duration: keyboardObserver.animationDuration, curve: keyboardObserver.animationCurve))
            .frame(height: keyboardObserver.keyboardHeight)
            .foregroundColor(.clear)
    }
}

#if DEBUG
struct KeyboardView_Previews : PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
#endif
