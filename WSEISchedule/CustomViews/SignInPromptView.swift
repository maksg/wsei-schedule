//
//  SignInPromptView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 21/02/2025.
//  Copyright © 2025 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct SignInPromptView: View {

    // MARK: - Properties

    var error: Error
    var action: () -> Void = {}

    private var errorText: String {
        if case WebAuthenticationSessionError.signedOut = error {
            .other(.errorSignedOut)
        } else {
            error.localizedDescription
        }
    }

    // MARK: - Views

    var body: some View {
        HStack {
            Spacer()
            Text(errorText)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Spacer()
            Button(action: action) {
                Text(.signIn(.signInAgain))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(8)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
        }
        .listRowBackground(Color.red)
    }

}
