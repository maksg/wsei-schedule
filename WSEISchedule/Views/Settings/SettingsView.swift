//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View, TabBarItemable {
    
    var tabBarItem: UITabBarItem { UITabBarItem(title: Tab.settings.title, image: .settings, tag: 1) }
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isSignInViewPresented: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.studentInfoRowViewModel != nil {
                    StudentInfoRow(viewModel: viewModel.studentInfoRowViewModel!)
                        .frame(height: 80)
                }
                #if !targetEnvironment(macCatalyst)
                Section(header: Text(Translation.Settings.Support.header.localized.uppercased())) {
                    ForEach(viewModel.supportDeveloperProducts, id: \.title) { product in
                        Button(action: {
                            self.viewModel.buy(product.product)
                        }, label: {
                            Text(product.title)
                                .foregroundColor(.main)
                        })
                    }
                }
                #endif
                Section(header: Text(Translation.Settings.Games.header.localized.uppercased())) {
                    ForEach(Games.allCases, content: GameRow.init)
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
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: .init(), onDismiss: self.viewModel.reloadLectures)
                .environmentObject(KeyboardObserver())
        }
        .alert(isPresented: $viewModel.showThankYouAlert) {
            Alert(title: Text(Translation.Settings.ThankYouAlert.title.localized),
                  message: Text(Translation.Settings.ThankYouAlert.message.localized),
                  dismissButton: .default(Text(Translation.Settings.ThankYouAlert.dismiss.localized)))
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
