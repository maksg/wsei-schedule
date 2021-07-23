//
//  SignInView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SignInView: View {

    // MARK: Methods

    @ObservedObject var viewModel: SignInViewModel

    // MARK: Views
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)

            Spacer()
            
            VStack(spacing: 4) {
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
            }
            
            VStack(spacing: 0) {
                TextField(viewModel.usernamePlaceholder, text: $viewModel.username)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 10)
                    .frame(height: 45)
                    .accessibility(identifier: "LoginTextField")
                
                Color.quaternary
                    .frame(height: 1)
                    .padding(.leading, 10)
                
                SecureField(viewModel.passwordPlaceholder, text: $viewModel.password)
                    .textContentType(.password)
                    .padding(.horizontal, 10)
                    .frame(height: 45)
                    .accessibility(identifier: "PasswordSecureField")
            }
            .background(Color.quaternaryBackground)
            .cornerRadius(10)
            
            Button(action: signIn) {
                Text(Translation.SignIn.signIn.localized)
                    .foregroundColor(.main)
            }
            .accessibility(identifier: "SignInButton")

            Spacer()
        }
        .frame(maxWidth: 500)
        .padding(26)
        .animation(.default)
        .keyboardAdaptive()
    }

    // MARK: Methods
    
    private func signIn() {
        viewModel.signIn()
    }

}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(apiRequest: APIRequest(), captchaReader: CaptchaReader(), htmlReader: HTMLReader()))
    }
}
