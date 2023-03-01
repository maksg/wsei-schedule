//
//  SignInable.swift
//  SignInable
//
//  Created by Maksymilian Galas on 22/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit

protocol SignInable: AnyObject, WebAuthenticationPresentationContextProviding {
    func startSigningIn()
    func startSigningIn(silently: Bool)
    func onSignIn()
    func onError(_ error: Error)
    func showErrorMessage(_ errorMessage: String)
}

extension SignInable {

    func presentationAnchor(for session: WebAuthenticationSession) -> WebAuthenticationSession.PresentationAnchor? {
        return UIApplication.shared.windows.first
    }

    func startSigningIn() {
        startSigningIn(silently: true)
    }

    func startSigningIn(silently: Bool) {
        let url = URL(string: "https://dziekanat.wsei.edu.pl/Konto/LogowanieStudenta")!
        let authSession = WebAuthenticationSession(url: url) { [weak self] result in
            switch result {
            case .success(let cookies):
                cookies.forEach(HTTPCookieStorage.shared.setCookie)
                UserDefaults.standard.cookies = cookies
                self?.onSignIn()
            case .failure(let error):
                self?.onError(error)
            }
        }

        authSession.presentationContextProvider = self
        authSession.start(silently: silently)
    }

    func onError(_ error: Error) {
        showErrorMessage(error.localizedDescription)
    }

    func resetErrors() {
        showErrorMessage("")
    }

}
