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

final class ScheduleViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties

    @DispatchMainPublished var errorMessage: String = ""
    @DispatchMainPublished var isRefreshing: Bool = true
    
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

    @DispatchMainPublished var lectureWeeks: [LectureWeek] = []
    var previousLectureWeeks: [LectureWeek] = []

    let apiRequest: APIRequest
    let htmlReader: HTMLReader

    private var session: WCSession?
    
    // MARK: - Initialization
    
    init(apiRequest: APIRequest, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()
        
        activateWatchSession()
        observeRemoveAllLecturesNotification()
    }
    
    // MARK: - Methods

    private func observeRemoveAllLecturesNotification() {
        NotificationCenter.default.addObserver(forName: .removeAllLectures, object: nil, queue: nil, using: removeAllLectures)
    }

    private func removeAllLectures(_: Notification) {
        lectures = []
    }
    
    func reloadLectures() async {
        fetchLectures(from: persistentContainer.viewContext)
        await fetchSchedule()
    }

    private func fetchSchedule() async {
        guard HTTPCookieStorage.shared.cookies?.isEmpty == false else {
            return
        }

        isRefreshing = true

        let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let toDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let parameters = ScheduleParameters(fromDate: fromDate, toDate: toDate)

        do {
            let html = try await apiRequest.getScheduleHtml(parameters: parameters).make()
            readLectures(fromHtml: html)
        } catch {
            onError(error)
        }
    }

    private func readLectures(fromHtml html: String) {
        do {
            let lectureDictionaries = try htmlReader.readLectures(fromHtml: html)
            let managedContext = persistentContainer.viewContext
            let lectures = lectureDictionaries.map { dictionary in
                CoreDataLecture(fromDictionary: dictionary, inContext: managedContext)
            }

            deleteLectures(from: managedContext)

            generateLectureDays(from: lectures)
            saveLectures(to: managedContext)

            WidgetCenter.shared.reloadAllTimelines()

            resetErrors()
        } catch {
            checkIfIsSignedIn(html: html, error: error)
        }
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
            let lectures = try context.fetch(fetchRequest)
            generateLectureDays(from: lectures)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func sendLecturesToWatch() {
        do {
            let codableLectures = lectures.map(CodableLecture.init)
            let data = try NSKeyedArchiver.archivedData(withRootObject: codableLectures, requiringSecureCoding: false)
            let context = ["lectures": data]
            try session?.updateApplicationContext(context)
        } catch {
            print(error)
        }
    }
    
    func generateLectureDays(from unsortedLectures: [CoreDataLecture]?) {
        lectures = unsortedLectures?.sorted { $0.fromDate < $1.fromDate } ?? []

        let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) ?? lectures.endIndex

        let futureLectures = lectures[nearestLectureIndex...]
        let lectureDays = Array<LectureDay>(lectures: futureLectures)
        lectureWeeks = Array(lectureDays: lectureDays)

        let previousLectures = lectures[..<nearestLectureIndex].reversed()
        let previousLectureDays = Array<LectureDay>(lectures: previousLectures)
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

    func onSignIn() {
        Task {
            await fetchSchedule()
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
        self.errorMessage = errorMessage
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
