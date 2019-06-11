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
        NavigationView {
            List {
                Section(header: Text("")) {
                    HStack {
                        Text(Translation.Settings.albumNumber.localized)
                            .font(.headline)
                        TextField($viewModel.albumNumber, placeholder: Text("00000"))
                            .font(.callout)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle(Text(viewModel.title))
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
