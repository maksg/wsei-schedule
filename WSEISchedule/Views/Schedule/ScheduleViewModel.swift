//
//  ScheduleViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import CoreData
import WatchConnectivity
import WidgetKit
import SwiftSoup
import StoreKit

final class ScheduleViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties

    @DispatchMainPublished var error: Error?
    @DispatchMainPublished var isRefreshing: Bool = false
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores { _, error in
            guard let error = error as NSError? else { return }
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return container
    }()

    private var lectures: [CoreDataLecture] = [] {
        didSet {
            sendLecturesToWatch()
        }
    }

    @DispatchMainPublished var lectureWeeks: [LectureWeek] = [] {
        didSet {
            firstLectureId = lectureWeeks.first?.lectureDays.first?.lectures.first?.id
        }
    }

    var previousLectureWeeks: [LectureWeek] = []
    var firstLectureId: String?

    var checkIfIsSignedIn: ((Error) -> Void)?

    let apiRequest: APIRequestable
    let htmlReader: HTMLReader

    private var session: WCSession?
    
    // MARK: - Initialization
    
    init(apiRequest: APIRequestable, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()
        
        activateWatchSession()
        observeDeleteAllLecturesNotification()
    }
    
    // MARK: - Methods

    private func observeDeleteAllLecturesNotification() {
        NotificationCenter.default.addObserver(forName: .deleteAllLectures, object: nil, queue: nil, using: deleteAllLectures)
    }

    private func deleteAllLectures(_: Notification) {
        let context = persistentContainer.viewContext
        deleteLectures(from: context)
        saveLectures(to: context)
        lectures = []
    }

    func showDetails(for lecture: Lecture) -> Bool {
        firstLectureId == lecture.id
    }
    
    func reload() async {
        fetchLectures(from: persistentContainer.viewContext)
        await fetchSchedule()
    }

    func fetchSchedule(showRefreshControl: Bool = true) async {
        guard isSignedIn && !isRefreshing else { return }
        isRefreshing = showRefreshControl

        let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let toDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let parameters = ScheduleParameters(fromDate: fromDate, toDate: toDate)

        do {
            let html = try await apiRequest.getScheduleHtml(parameters: parameters)
            readLectures(fromHtml: html)
        } catch {
            showError(error)
        }
    }

    private func readLectures(fromHtml html: String) {
        do {
            let lectureDictionaries = try htmlReader.readLectures(fromHtml: html)

            guard isSignedIn else {
                isRefreshing = false
                return
            }
            
            let context = persistentContainer.viewContext
            deleteLectures(from: context)

            lectures = lectureDictionaries.map { dictionary in
                CoreDataLecture(fromDictionary: dictionary, in: context)
            }

            generateLectureDays(from: lectures)
            saveLectures(to: context)

            WidgetCenter.shared.reloadAllTimelines()

            showError(nil)

            DispatchQueue.main.async { [weak self] in
                self?.requestReviewIfAppropriate()
            }
        } catch {
            checkIfIsSignedIn?(error)
        }
    }

    private func requestReviewIfAppropriate() {
        let appVersion = Bundle.main.appVersion
        let userDefaults = UserDefaults.standard
        guard appVersion != userDefaults.lastVersionPromptedForReview else { return }
        userDefaults.lecturesFetchCount += 1

        guard userDefaults.lecturesFetchCount > 10, let scene = UIApplication.shared.foregroundActiveScene else { return }
        userDefaults.lecturesFetchCount = 0
        userDefaults.lastVersionPromptedForReview = appVersion
        SKStoreReviewController.requestReview(in: scene)
    }
    
    func activateWatchSession() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    private func fetchLectures(from context: NSManagedObjectContext) {
        let fetchRequest = CoreDataLecture.fetchRequest()

        do {
            lectures = try context.fetch(fetchRequest)
            generateLectureDays(from: lectures)
        } catch {
            print(error)
        }
    }
    
    private func sendLecturesToWatch() {
        do {
            guard let lecturesData = lectures.compactMap(Lecture.init).encoded else { return }
            let context = ["lectures": lecturesData]
            try session?.updateApplicationContext(context)
        } catch {
            print(error)
        }
    }
    
    private func generateLectureDays(from unsortedLectures: [CoreDataLecture]) {
        let lectures = unsortedLectures.compactMap(Lecture.init).sorted { $0.fromDate < $1.fromDate }

        let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) ?? lectures.endIndex

        let futureLectures = lectures[nearestLectureIndex...]
        let lectureDays = Array(lectures: futureLectures)
        lectureWeeks = Array(lectureDays: lectureDays)

        let previousLectures = lectures[..<nearestLectureIndex].reversed()
        let previousLectureDays = Array(lectures: previousLectures)
        previousLectureWeeks = Array(lectureDays: previousLectureDays)
    }
    
    private func deleteLectures(from context: NSManagedObjectContext) {
        lectures.forEach(context.delete)
    }
    
    private func saveLectures(to context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

}

extension ScheduleViewModel: SignInable {

    func showError(_ error: Error?) {
        self.error = error
        self.isRefreshing = false
    }
    
}

extension ScheduleViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        sendLecturesToWatch()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
}
