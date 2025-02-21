//
//  GradesViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class GradesViewModel: ObservableObject {

    // MARK: - Properties

    @DispatchMainPublished var error: Error?
    @DispatchMainPublished var isRefreshingAll: Bool = false
    @DispatchMainPublished var isRefreshing: Set<String> = []
    @DispatchMainPublished var isExpanded: Set<String> = [] {
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
    @DispatchMainPublished var gradeSemesters: [GradeSemester] = UserDefaults.standard.gradeSemesters

    var checkIfIsSignedIn: ((Error) -> Void)?
    var startSigningIn: (() -> Void)?

    let apiRequest: APIRequestable
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequestable, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader

        if let id = gradeSemesters.first?.id {
            self.isExpanded = [id]
        }
    }

    // MARK: - Methods

    func fetchGradeSemesters(showRefreshControl: Bool = true) async {
        guard isSignedIn && !isRefreshingAll else { return }
        isRefreshingAll = showRefreshControl

        do {
            let html = try await apiRequest.getGradeSemestersHtml()
            readGradeSemesters(fromHtml: html)
        } catch {
            showError(error)
        }
    }

    private func readGradeSemesters(fromHtml html: String) {
        do {
            let gradeSemesters = try htmlReader.readGradeSemesters(fromHtml: html)

            guard isSignedIn else {
                isRefreshingAll = false
                return
            }
            
            UserDefaults.standard.gradeSemesters = gradeSemesters

            if let currentSemesterId = gradeSemesters.first?.id {
                isExpanded = [currentSemesterId]
            }
            self.gradeSemesters = gradeSemesters

            showError(nil)
        } catch {
            checkIfIsSignedIn?(error)
        }
    }

    private func fetchGrades(forSemesterId semesterId: String) async {
        isRefreshing.insert(semesterId)

        do {
            let html = try await apiRequest.getGradesHtml(semesterId: semesterId)
            readGrades(fromHtml: html, semesterId: semesterId)
        } catch {
            showError(error)
            isRefreshing.remove(semesterId)
        }
    }

    private func readGrades(fromHtml html: String, semesterId: String) {
        do {
            let grades = try htmlReader.readGrades(fromHtml: html)

            guard let index = gradeSemesters.firstIndex(where: { $0.id == semesterId }) else { return }
            gradeSemesters[index].grades = grades
            isRefreshing.remove(semesterId)

            showError(nil)
        } catch {
            showError(error)
            isRefreshing.remove(semesterId)
        }
    }
    
}

extension GradesViewModel: SignInable {

    func showError(_ error: Error?) {
        self.error = error
        self.isRefreshingAll = false
    }

}
