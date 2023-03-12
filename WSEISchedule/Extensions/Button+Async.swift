//
//  Button+Async.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 12/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension Button {

    init(action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: {
            Task {
                await action()
            }
        }, label: label)
    }

}
