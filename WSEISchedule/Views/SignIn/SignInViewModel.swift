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
    
    var username: String = ""
    var password: String = ""
    
    var usernamePlaceholder: String { Translation.SignIn.username.localized }
    var passwordPlaceholder: String { Translation.SignIn.password.localized }

    var finishSignIn: (() -> Void)?

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

        finishSignIn?()
    }

    func onError(_ error: Error) {
        print(error)
    }

}
