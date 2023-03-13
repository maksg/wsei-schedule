//
//  SignInViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class SignInViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    var isSigningIn: Bool = false
    var finishSignIn: (() -> Void)?

    // MARK: - Methods

    func signIn() {
        #if MOCK
        let cookie = HTTPCookie(properties: [
            .name: "ASP.NET_SessionId",
            .value: "mock",
            .domain: "dziekanat.wsei.edu.pl",
            .path: "/"
        ])!
        UserDefaults.standard.cookies = [cookie]
        onSignIn()
        #else
        startSigningIn(silently: false)
        #endif
    }
    
}

extension SignInViewModel: SignInable {

    func onSignIn() {
        resetErrors()
        finishSignIn?()
    }
    
    func showErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }

}
