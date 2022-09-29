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
    @Binding var isSignedIn: Bool

    // MARK: Views
    
    var body: some View {
        List {
            SettingsViewContent(viewModel: viewModel, isSignedIn: $isSignedIn)
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Tab.settings.title)
        .accessibility(identifier: "SettingsList")
    }
    
}

struct SettingsViewContent: View {

    // MARK: Properties

    @ObservedObject var viewModel: SettingsViewModel
    @Binding var isSignedIn: Bool

    // MARK: Views

    var body: some View {
        Group {
            if let studentInfoRowViewModel = viewModel.studentInfoRowViewModel {
                Section {
                    StudentInfoRow(viewModel: studentInfoRowViewModel)
                        .frame(height: 80)
                }
            }

            Section(header: Text(Translation.Settings.Support.header.localized.uppercased())) {
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

            Section(header: Text(Translation.Settings.Games.header.localized.uppercased())) {
                ForEach(Games.allCases, content: GameRow.init)
            }

            Section {
                Button(action: signOut) {
                    HStack {
                        Image.signOut
                            .foregroundColor(.red)
                        Text(Translation.SignIn.signOut.localized)
                            .foregroundColor(.main)
                    }
                }
                .accessibility(identifier: "SignOutButton")
            }
        }
        .onAppear(perform: loadStudentInfo)
        .alert(isPresented: $viewModel.showThankYouAlert) {
            Alert(title: Text(Translation.Settings.ThankYouAlert.title.localized),
                  message: Text(Translation.Settings.ThankYouAlert.message.localized),
                  dismissButton: .default(Text(Translation.Settings.ThankYouAlert.dismiss.localized)))
        }
    }

    // MARK: Methods

    private func loadStudentInfo() {
        viewModel.loadStudentInfo()
    }

    private func signOut() {
        viewModel.signOut()
        DispatchQueue.main.async {
            isSignedIn = false
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(apiRequest: APIRequest(), captchaReader: CaptchaReader(), htmlReader: HTMLReader()), isSignedIn: .constant(true))
    }
}
