//
//  SignInView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        KeyboardView(.white) {
            VStack(spacing: 30) {
                Image("logo").resizable().aspectRatio(contentMode: .fit)
                
                Text(Translation.SignIn.title.localized)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 8) {
                    TextField(viewModel.loginPlaceholder, text: $viewModel.login)
                        .textContentType(.username)
                        .autocapitalization(.none)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    
                    SecureField(viewModel.passwordPlaceholder, text: $viewModel.password)
                        .textContentType(.password)
                        .padding(.horizontal, 10)
                        .frame(height: 30)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                Button(action: signIn, label: {
                    Text(Translation.SignIn.signIn.localized)
                        .foregroundColor(.main)
                })
            }.padding(26)
            .animation(.default)
        }
    }
    
    private func signIn() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: .init())
            .environmentObject(KeyboardObserver(window: UIApplication.shared.windows.first!))
    }
}
