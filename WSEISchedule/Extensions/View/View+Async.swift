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

    func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) async -> Void) -> some View where V: Equatable {
        onChange(of: value) { newValue in
            Task {
                await action(newValue)
            }
        }
    }

}
