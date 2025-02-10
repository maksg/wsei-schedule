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
    @AppStorage(UserDefaults.Key.cookies.rawValue) private var cookies: Data?
    private var isSignedIn: Bool { cookies != nil }

    private let viewModel: RootViewModel = RootViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
        }
        .commands {
            CommandGroup(replacing: .systemServices, addition: {})
            CommandGroup(replacing: .textFormatting, addition: {})
            CommandGroup(replacing: .saveItem, addition: {})
            CommandGroup(replacing: .importExport, addition: {})
            CommandGroup(replacing: .printItem, addition: {})

            CommandGroup(replacing: .newItem) {
                Button(.other(.menuBarRefresh)) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("r"))
                }
                .keyboardShortcut("r")
                .disabled(!isSignedIn)
            }

            CommandGroup(replacing: .toolbar) {
                Button(.schedule(.title)) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("1"))
                }
                .keyboardShortcut("1")
                .disabled(!isSignedIn)

                Button(.grades(.title)) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("2"))
                }
                .keyboardShortcut("2")
                .disabled(!isSignedIn)
            }
        }
    }
}
