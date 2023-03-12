//
//  View+PullToRefresh.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 07/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    func pullToRefresh(onRefresh: @escaping () async -> Void) -> some View {
        #if targetEnvironment(macCatalyst)
        return self
        #else
        if #available(iOS 15.0, *) {
            return refreshable {
                await onRefresh()
            }
        } else {
            return VStack(spacing: 0) {
                self
                PullToRefreshView(onRefresh: onRefresh).frame(height: 0)
            }
        }
        #endif
    }

}
