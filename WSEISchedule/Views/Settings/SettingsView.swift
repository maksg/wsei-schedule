//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObjectBinding var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("")) {
                    HStack {
                        Text(Translation.Settings.albumNumber.localized)
                            .font(.headline)
                        TextField($viewModel.albumNumber,
                                  placeholder: Text(viewModel.albumNumberPlaceholder))
                            .font(.callout)
                    }
                }
            }
            .listStyle(.grouped)
            .tapAction {
                UIApplication.shared.keyWindow?.endEditing(true)
            }
            
            KeyboardView()
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
