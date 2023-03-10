//
//  WSEISchedule.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

@main
struct WSEISchedule: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
    }
}
