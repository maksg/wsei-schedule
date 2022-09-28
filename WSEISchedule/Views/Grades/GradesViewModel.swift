//
//  GradesViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class GradesViewModel: NSObject, ObservableObject {

    // MARK: Properties

    var unsuccessfulSignInAttempts: Int = 0

    @Published var errorMessage: String = ""
    @Published var isRefreshing: Bool = false

    @Published var grades: [Grade] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.isRefreshing = false
            }
        }
    }

    let apiRequest: APIRequest
    let captchaReader: CaptchaReader
    let htmlReader: HTMLReader

    // MARK: Initialization

    init(apiRequest: APIRequest, captchaReader: CaptchaReader, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.captchaReader = captchaReader
        self.htmlReader = htmlReader
        super.init()
    }

    // MARK: Methods

    func reloadGrades() {
        DispatchQueue.main.async { [weak self] in
            self?.isRefreshing = true
        }
        fetchGrades()
    }

    private func fetchGrades() {
        apiRequest.getGradesHtml().onDataSuccess({ [weak self] html in
            self?.readGrades(fromHtml: html)
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
    }

    private func readGrades(fromHtml html: String) {
        do {
            let gradesDictionary = try htmlReader.readGrades(fromHtml: html)
            self.grades = gradesDictionary.map(Grade.init).filter({ !$0.value.isEmpty })
            resetErrors()
        } catch {
            onError(error)
        }
    }
    
}

extension GradesViewModel: SignInable {

    func onSignIn(html: String, username: String, password: String) {
        fetchGrades()
    }

    func onError(_ error: Error) {
        onSignInError(error)
    }

    func showErrorMessage(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = errorMessage

            guard !errorMessage.isEmpty else { return }
            self?.isRefreshing = false
        }
    }

}
