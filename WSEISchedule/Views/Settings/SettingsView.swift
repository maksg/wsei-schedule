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
            Form {
                if viewModel.isSignedIn {
                    Button(action: signOut) {
                        Text(Translation.SignIn.signOut.localized)
                            .foregroundColor(.main)
                    }
                } else {
                    Button(action: signIn) {
                        Text(Translation.SignIn.signIn.localized)
                            .foregroundColor(.main)
                    }
                }
            }
            .navigationBarTitle(Tab.settings.title)
        }
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: .init())
                .environmentObject(KeyboardObserver())
        }
    }
    
    private func signIn() {
        isSignInViewPresented = true
    }
    
    private func signOut() {
        viewModel.signOut()
        isSignInViewPresented = true
    }
    
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init())
    }
}
