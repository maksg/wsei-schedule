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

    var finishSignIn: (() -> Void)?

    // MARK: - Methods

    func signIn() {
        startSigningIn(silently: false)
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
