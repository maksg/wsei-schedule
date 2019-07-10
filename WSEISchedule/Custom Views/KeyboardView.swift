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
    var viewFrame: CGRect

    var body: some View {
        keyboardObserver.viewFrame = viewFrame
        return Rectangle()
            .fill(Color.clear)
            .frame(height: keyboardObserver.height)
            .animation(.basic(duration: keyboardObserver.animationDuration, curve: keyboardObserver.animationCurve))
    }
}

#if DEBUG
struct KeyboardView_Previews : PreviewProvider {
    static var previews: some View {
        KeyboardView(viewFrame: .zero)
    }
}
#endif
