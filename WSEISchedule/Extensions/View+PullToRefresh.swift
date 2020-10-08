//
//  View+PullToRefresh.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 07/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension View {

    func pullToRefresh(onRefresh: @escaping () -> Void, isRefreshing: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            self
            PullToRefreshView(onRefresh: onRefresh, isRefreshing: isRefreshing).frame(height: 0)
        }
    }

}
