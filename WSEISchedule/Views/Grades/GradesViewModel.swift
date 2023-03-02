//
//  GradesViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class GradesViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var errorMessage: String = ""
    @Published var isRefreshing: Bool = false

    @Published var grades: [Grade] = []

    let apiRequest: APIRequest
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequest, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()
    }

    // MARK: - Methods

    func reloadGrades() async {
        await fetchGrades()
    }

    private func fetchGrades() async {
        guard HTTPCookieStorage.shared.cookies?.isEmpty == false else {
            return
        }

        do {
            let html = try await apiRequest.getGradesHtml().make()
            readGrades(fromHtml: html)
        } catch {
            onError(error)
        }
    }

    private func readGrades(fromHtml html: String) {
        do {
            let gradesDictionary = try htmlReader.readGrades(fromHtml: html)
            grades = gradesDictionary.map(Grade.init).filter({ !$0.value.isEmpty })
            resetErrors()
        } catch {
            onError(error)
        }
    }
    
}

extension GradesViewModel: SignInable {

    func onSignIn() {
        Task {
            await fetchGrades()
        }
    }

    func showErrorMessage(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = errorMessage

            guard !errorMessage.isEmpty else { return }
            self?.isRefreshing = false
        }
    }

}
