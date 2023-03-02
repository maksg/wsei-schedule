//
//  View+Async.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 02/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

extension View {

    func onAppear(perform action: @escaping () async -> Void) -> some View {
        onAppear {
            Task {
                await action()
            }
        }
    }

    func onWillEnterForeground(perform action: @escaping () async -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task {
                await action()
            }
        }
    }

}
