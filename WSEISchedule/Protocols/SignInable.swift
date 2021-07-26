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

    func startSigningIn(username: String, password: String)
    func onSignIn(html: String, username: String, password: String)
    func onError(_ error: Error)
}

extension SignInable {

    func startSigningIn(username: String, password: String) {
        apiRequest.getSignInHtml().onDataSuccess({ [weak self] html in
            self?.readSignInData(fromHtml: html, username: username, password: password)
        }).onError({ [weak self] error in
            self?.onError(error)
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
            onError(error)
        }
    }

    private func downloadCaptcha(path: String, signInData: SignInData, username: String, password: String) {
        apiRequest.downloadImage(path: path).onImageDownloadSuccess({ [weak self] image in
            if let image = image {
                self?.readCaptcha(from: image, signInData: signInData, username: username, password: password)
            }
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
    }

    private func readCaptcha(from image: UIImage, signInData: SignInData, username: String, password: String) {
        captchaReader.readCaptcha(image) { [weak self] result in
            switch result {
            case .success(let captcha):
                self?.finishSigningIn(data: signInData, username: username, password: password, captcha: captcha)
            case .failure(let error):
                self?.onError(error)
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
            self?.onSignIn(html: html, username: username, password: password)
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
    }

}
