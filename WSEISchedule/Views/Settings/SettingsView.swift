//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isSignInViewPresented: Bool = false
    
    private func gameRow(for game: Games) -> some View {
        Button(action: {
            UIApplication.shared.open(game.url, options: [:])
        }, label: {
            HStack {
                Image(game.name)
                    .renderingMode(.original)
                    .cornerRadius(10)
                Text(game.name)
                    .foregroundColor(.main)
            }
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.studentInfoRowViewModel != nil {
                    StudentInfoRow(viewModel: viewModel.studentInfoRowViewModel!)
                        .frame(height: 80)
                }
                Section(header: Text(Translation.Settings.Games.header.localized.uppercased())) {
                    ForEach(Games.allCases, content: gameRow)
                }
                Section {
                    Button(action: signInOrOut) {
                        Text(viewModel.signButtonText)
                            .foregroundColor(.main)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Tab.settings.title)
        }
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: .init(), onDismiss: self.viewModel.reloadLectures)
                .environmentObject(KeyboardObserver())
        }
    }
    
    private func signInOrOut() {
        if viewModel.isSignedIn {
            viewModel.signOut()
        }
        isSignInViewPresented = true
    }
    
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init(webView: ScheduleWebView()))
    }
}
