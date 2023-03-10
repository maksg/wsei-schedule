//
//  WSEIScheduleWatch.swift
//  WSEIScheduleWatch
//
//  Created by Maksymilian Galas on 07/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

@main
struct WSEIScheduleWatch: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
