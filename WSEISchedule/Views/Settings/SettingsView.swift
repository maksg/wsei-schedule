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
    
    var body: some View {
        NavigationView {
            List {
                Button(action: signInOrOut) {
                    Text(viewModel.signButtonText)
                        .foregroundColor(.main)
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Tab.settings.title)
        }
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: .init())
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
        SettingsView(viewModel: .init())
    }
}
