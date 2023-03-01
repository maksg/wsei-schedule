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
    
    @Published var username: String = ""
    @Published var password: String = ""

    var finishSignIn: (() -> Void)?

    var unsuccessfulSignInAttempts: Int = 0

    let apiRequest: APIRequest
    let captchaReader: CaptchaReader
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequest, captchaReader: CaptchaReader, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.captchaReader = captchaReader
        self.htmlReader = htmlReader
    }

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
