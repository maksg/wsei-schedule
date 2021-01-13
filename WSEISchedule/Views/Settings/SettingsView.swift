//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    // MARK: Properties
    
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var isSignInViewPresented: Bool

    // MARK: Views
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.studentInfoRowViewModel != nil {
                    StudentInfoRow(viewModel: viewModel.studentInfoRowViewModel!)
                        .frame(height: 80)
                }
                Section(header: Text(Translation.Settings.Support.header.localized.uppercased())) {
                    ForEach(viewModel.supportDeveloperProducts, id: \.title) { product in
                        Button(action: {
                            viewModel.buy(product.product)
                        }, label: {
                            Text(product.title)
                                .foregroundColor(.main)
                        })
                    }
                }
                Section(header: Text(Translation.Settings.Games.header.localized.uppercased())) {
                    ForEach(Games.allCases, content: GameRow.init)
                }
                Section {
                    Button(action: signInOrOut) {
                        HStack {
                            Image.singOut
                                .foregroundColor(.red)
                            Text(viewModel.signButtonText)
                                .foregroundColor(.main)
                        }
                    }
                }
            }
            .insetGroupedListStyle()
            .navigationBarTitle(Tab.settings.title)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.showThankYouAlert) {
            Alert(title: Text(Translation.Settings.ThankYouAlert.title.localized),
                  message: Text(Translation.Settings.ThankYouAlert.message.localized),
                  dismissButton: .default(Text(Translation.Settings.ThankYouAlert.dismiss.localized)))
        }
    }

    // MARK: Methods
    
    private func signInOrOut() {
        if viewModel.isSignedIn {
            viewModel.signOut()
        }
        isSignInViewPresented = true
    }
    
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(webView: ScheduleWebView()), isSignInViewPresented: .constant(false))
    }
}
