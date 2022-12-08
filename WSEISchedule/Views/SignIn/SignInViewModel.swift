//
//  SignInViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {

    // MARK: Properties
    
    @Published var username: String = ""
    @Published var password: String = ""

    var finishSignIn: (() -> Void)?

    var unsuccessfulSignInAttempts: Int = 0

    let apiRequest: APIRequest
    let captchaReader: CaptchaReader
    let htmlReader: HTMLReader

    // MARK: Initialization

    init(apiRequest: APIRequest, captchaReader: CaptchaReader, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.captchaReader = captchaReader
        self.htmlReader = htmlReader
    }

    // MARK: Methods

    func signIn() {
        startSigningIn(username: username, password: password)
    }
    
}

extension SignInViewModel: SignInable {

    func onSignIn(html: String, username: String, password: String) {
        UserDefaults.standard.student.login = username
        UserDefaults.standard.student.password = password

        resetErrors()
        finishSignIn?()
    }

    func onError(_ error: Error) {
        signIn()
    }
    
    func onErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }

}
