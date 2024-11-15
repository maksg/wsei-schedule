//
//  SignInView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SignInView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: SignInViewModel

    // MARK: - Views

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)

            Spacer()
            
            Text(Translation.SignIn.title.localized)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(Translation.SignIn.privacyMessage.localized)
                .font(.footnote)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
            
            Button(action: signIn) {
                Text(Translation.SignIn.signIn.localized)
                    .font(.headline)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                    .cornerRadius(16)
                    .foregroundColor(.white)
            }
            .accessibilityIdentifier("SignInButton")
        }
        .frame(maxWidth: 500)
        .padding(26)
        .animation(.default)
    }

    // MARK: - Methods

    private func signIn() {
        viewModel.signIn()
    }

}

// MARK: -

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
