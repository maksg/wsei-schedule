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
        .commands {
            CommandGroup(replacing: .systemServices, addition: {})
            CommandGroup(replacing: .textFormatting, addition: {})
            CommandGroup(replacing: .saveItem, addition: {})
            CommandGroup(replacing: .importExport, addition: {})
            CommandGroup(replacing: .printItem, addition: {})
            CommandGroup(replacing: .newItem) {
                Button(Translation.MenuBar.refresh.localized) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("r"))
                }.keyboardShortcut("r")
            }
            CommandGroup(replacing: .toolbar) {
                Button(Translation.Schedule.title.localized) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("1"))
                }.keyboardShortcut("1")

                Button(Translation.Grades.title.localized) {
                    NotificationCenter.default.post(name: .keyboardShortcut, object: KeyboardShortcut("2"))
                }.keyboardShortcut("2")
            }
        }
    }
}
