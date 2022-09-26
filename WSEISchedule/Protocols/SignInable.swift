//
//  SignInable.swift
//  SignInable
//
//  Created by Maksymilian Galas on 22/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit

protocol SignInable: AnyObject {
    var apiRequest: APIRequest { get }
    var captchaReader: CaptchaReader { get }
    var htmlReader: HTMLReader { get }
    var unsuccessfulSignInAttempts: Int { get set }

    func startSigningIn(username: String, password: String)
    func onSignIn(html: String, username: String, password: String)
    func onError(_ error: Error)
    func onSignInError(_ error: Error)
    func onSignInError(_ error: Error, username: String, password: String)
    func showErrorMessage(_ errorMessage: String)
    func resetErrors()
}

extension SignInable {

    func startSigningIn(username: String, password: String) {
        apiRequest.getSignInHtml().onDataSuccess({ [weak self] html in
            self?.readSignInData(fromHtml: html, username: username, password: password)
        }).onError({ [weak self] error in
            self?.onSignInError(error, username: username, password: password)
        }).make()
    }

    private func readSignInData(fromHtml html: String, username: String, password: String) {
        do {
            let signInData = try htmlReader.readSignInData(fromHtml: html)

            if let captchaSrc = signInData.captchaSrc {
                downloadCaptcha(path: captchaSrc, signInData: signInData, username: username, password: password)
            } else {
                finishSigningIn(data: signInData, username: username, password: password)
            }
        } catch {
            onSignInError(error, username: username, password: password)
        }
    }

    private func downloadCaptcha(path: String, signInData: SignInData, username: String, password: String) {
        apiRequest.downloadImage(path: path).onImageDownloadSuccess({ [weak self] image in
            guard let image = image else {
                self?.onSignInError(HTMLReaderError.invalidCaptcha, username: username, password: password)
                return
            }
            self?.readCaptcha(from: image, signInData: signInData, username: username, password: password)
        }).onError({ [weak self] error in
            self?.onSignInError(error, username: username, password: password)
        }).make()
    }

    private func readCaptcha(from image: UIImage, signInData: SignInData, username: String, password: String) {
        captchaReader.readCaptcha(image) { [weak self] result in
            switch result {
            case .success(let captcha):
                self?.finishSigningIn(data: signInData, username: username, password: password, captcha: captcha)
            case .failure(let error):
                self?.onSignInError(error, username: username, password: password)
            }
        }
    }

    private func finishSigningIn(data: SignInData, username: String, password: String, captcha: String? = nil) {
        let parameters = SignInParameters(
            usernameId: data.usernameId,
            passwordId: data.passwordId,
            username: username,
            password: password,
            captcha: captcha
        )

        apiRequest.signIn(parameters: parameters).onDataSuccess({ [weak self] html in
            self?.checkForError(html: html, username: username, password: password)
        }).onError({ [weak self] error in
            self?.onSignInError(error, username: username, password: password)
        }).make()
    }

    private func checkForError(html: String, username: String, password: String) {
        do {
            let errorMessage = try htmlReader.readSignInError(fromHtml: html)
            showErrorMessage(errorMessage)
        } catch HTMLReaderError.invalidHtml {
            showErrorMessage("")
            onSignIn(html: html, username: username, password: password)
        } catch {
            showErrorMessage("")
            onSignInError(error, username: username, password: password)
        }
    }

    func onSignInError(_ error: Error) {
        let student = UserDefaults.standard.student
        onSignInError(error, username: student.login, password: student.password)
    }

    func onSignInError(_ error: Error, username: String, password: String) {
        unsuccessfulSignInAttempts += 1

        if unsuccessfulSignInAttempts < 4 {
            startSigningIn(username: username, password: password)
        } else {
            unsuccessfulSignInAttempts = 0
            showErrorMessage(error.localizedDescription)
        }
    }

    func resetErrors() {
        showErrorMessage("")
        unsuccessfulSignInAttempts = 0
    }

}
