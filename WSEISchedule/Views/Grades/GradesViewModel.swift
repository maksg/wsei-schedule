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

    @Published var grades: [Grade] = [] {
        didSet {
            stopRefreshing()
        }
    }

    let apiRequest: APIRequest
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequest, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()
    }

    // MARK: - Methods

    func reloadGrades() {
        startRefreshing()
        fetchGrades()
    }

    private func fetchGrades() {
        guard HTTPCookieStorage.shared.cookies?.isEmpty == false else {
            stopRefreshing()
            return
        }
        
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

    private func startRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.isRefreshing = true
        }
    }

    private func stopRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.isRefreshing = false
        }
    }
    
}

extension GradesViewModel: SignInable {

    func onSignIn() {
        fetchGrades()
    }

    func showErrorMessage(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = errorMessage

            guard !errorMessage.isEmpty else { return }
            self?.isRefreshing = false
        }
    }

}
