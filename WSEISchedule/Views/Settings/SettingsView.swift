//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    @ObjectBinding var viewModel: SettingsViewModel
    
    var body: some View {
        KeyboardView {
            NavigationView {
                Form {
                    TextFieldRow(Translation.Settings.albumNumber.localized,
                                 placeholder: self.viewModel.albumNumberPlaceholder,
                                 text: self.$viewModel.albumNumber)
                }
                .navigationBarTitle(Tab.settings.title)
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init())
    }
}
#endif
