//
//  View+ScrollToTop.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

extension View {

    func scrollToTop<P>(_ publisher: P, condition: @escaping () -> Bool = { true }) -> some View where P : Publisher, P.Failure == Never {
        ScrollViewReader { proxy in
            self.onReceive(publisher) { _ in
                guard condition() else { return }
                withAnimation {
                    proxy.scrollTo(ScrollToTopView.id)
                }
            }
        }
    }

}
