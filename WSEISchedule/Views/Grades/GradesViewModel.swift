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

    var student: Student {
        get {
            UserDefaults.standard.student
        }
        set {
            UserDefaults.standard.student = newValue
        }
    }

    var unsuccessfulSignInAttempts: Int = 0

    @Published var errorMessage: String = ""
    @Published var isRefreshing: Bool = false

    @Published var grades: [Grade] = []

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
        grades = [MockData.grade]
    }

    func setErrorMessage(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = errorMessage

            guard !errorMessage.isEmpty else { return }
            self?.isRefreshing = false
        }
    }
    
}

extension GradesViewModel: SignInable {

    func onSignIn(html: String, username: String, password: String) {
    }

    func onError(_ error: Error) {
        onSignInError(error, username: student.login, password: student.password)
    }

    func onErrorMessage(_ errorMessage: String) {
        setErrorMessage(errorMessage)
    }

}
