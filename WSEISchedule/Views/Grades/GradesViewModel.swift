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
    @Published var isRefreshingAll: Bool = true
    @Published var isRefreshing: Set<String> = []
    @Published var isExpanded: Set<String> = [] {
        didSet {
            let ids = isExpanded.filter { id in
                !oldValue.contains(id) && gradeSemesters.first(where: { $0.id == id })?.grades.isEmpty == true
            }
            Task {
                for id in ids {
                    await fetchGrades(forSemesterId: id)
                }
            }
        }
    }
    @Published var gradeSemesters: [GradeSemester] = UserDefaults.standard.gradeSemesters

    let apiRequest: APIRequest
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequest, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()

        if let id = gradeSemesters.first?.id {
            self.isExpanded = [id]
        }
    }

    // MARK: - Methods

    func fetchGradeSemesters() async {
        guard HTTPCookieStorage.shared.cookies?.isEmpty == false else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.isRefreshingAll = true
        }

        do {
            let html = try await apiRequest.getGradeSemesterHtml().make()
            readGradeSemesters(fromHtml: html)
        } catch {
            onError(error)
        }
    }

    private func readGradeSemesters(fromHtml html: String) {
        do {
            let gradeSemesters = try htmlReader.readGradeSemesters(fromHtml: html)
            UserDefaults.standard.gradeSemesters = gradeSemesters

            DispatchQueue.main.async { [weak self] in
                if let currentSemesterId = gradeSemesters.first?.id {
                    self?.isExpanded = [currentSemesterId]
                }
                self?.gradeSemesters = gradeSemesters
            }
            resetErrors()
        } catch {
            checkIfIsSignedIn(html: html, error: error)
        }
    }

    private func fetchGrades(forSemesterId semesterId: String) async {
        DispatchQueue.main.async { [weak self] in
            self?.isRefreshing.insert(semesterId)
        }

        do {
            let html = try await apiRequest.getGradesHtml(semesterId: semesterId).make()
            readGrades(fromHtml: html, semesterId: semesterId)
        } catch {
            onError(error)
            DispatchQueue.main.async { [weak self] in
                self?.isRefreshing.remove(semesterId)
            }
        }
    }

    private func readGrades(fromHtml html: String, semesterId: String) {
        do {
            let grades = try htmlReader.readGrades(fromHtml: html)

            DispatchQueue.main.async { [weak self] in
                guard let index = self?.gradeSemesters.firstIndex(where: { $0.id == semesterId }) else { return }
                self?.gradeSemesters[index].grades = grades
                self?.isRefreshing.remove(semesterId)
            }
            resetErrors()
        } catch {
            onError(error)
            DispatchQueue.main.async { [weak self] in
                self?.isRefreshing.remove(semesterId)
            }
        }
    }
    
}

extension GradesViewModel: SignInable {

    func onSignIn() {
        Task {
            await fetchGradeSemesters()
        }
    }

    private func checkIfIsSignedIn(html: String, error: Error) {
        let isSignedIn = htmlReader.isSignedIn(fromHtml: html)
        if isSignedIn {
            onError(error)
        } else {
            startSigningIn()
        }
    }

    func showErrorMessage(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = errorMessage
            self?.isRefreshingAll = false
        }
    }

}
