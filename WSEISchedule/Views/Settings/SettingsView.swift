//
//  SettingsView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties
    
    @ObservedObject var viewModel: SettingsViewModel
    @MainActor @Binding var isSignedIn: Bool

    // MARK: - Views
    
    var body: some View {
        List {
            SettingsViewContent(viewModel: viewModel, isSignedIn: $isSignedIn)
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Tab.settings.title)
        .accessibilityIdentifier("SettingsList")
    }
    
}

struct SettingsViewContent: View {

    // MARK: - Properties

    @ObservedObject var viewModel: SettingsViewModel
    @Binding var isSignedIn: Bool

    // MARK: - Views

    var body: some View {
        Group {
            Section {
                if viewModel.isRefreshing {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .id(UUID())
                } else {
                    StudentInfoRow(viewModel: viewModel.studentInfoRowViewModel)
                }
            }
            .frame(height: 80)

            Section(header: Text(String.settings(.supportHeader).uppercased())) {
                ForEach(viewModel.supportDeveloperProducts, id: \.title) { product in
                    Button(action: {
                        viewModel.buy(product.product)
                    }, label: {
                        HStack {
                            Image(uiImage: product.image)
                            Text(product.title)
                                .foregroundColor(.main)
                        }
                    })
                }
            }

            Section(header: Text(String.settings(.gamesHeader).uppercased())) {
                ForEach(Games.allCases, content: GameRow.init)
            }

            Section {
                Button(action: signOut) {
                    HStack {
                        Image.signOut
                            .foregroundColor(.red)
                        Text(.signIn(.signOut))
                            .foregroundColor(.main)
                    }
                }
                .accessibilityIdentifier("SignOutButton")
            }
        }
        .alert(isPresented: $viewModel.showThankYouAlert) {
            Alert(
                title: Text(.settings(.thankYouAlertTitle)),
                message: Text(.settings(.thankYouAlertMessage)),
                dismissButton: .default(Text(.settings(.thankYouAlertDismiss)))
            )
        }
    }

    // MARK: - Methods

    private func signOut() {
        viewModel.signOut()
        Task { @MainActor in
            isSignedIn = false
        }
    }

}

// MARK: -

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(apiRequest: APIRequestMock(), htmlReader: HTMLReader()), isSignedIn: .constant(true))
    }
}
