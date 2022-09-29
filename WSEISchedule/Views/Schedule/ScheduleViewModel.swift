//
//  ScheduleViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import WebKit
import CoreData
import WatchConnectivity
import WidgetKit
import SwiftSoup

final class ScheduleViewModel: NSObject, ObservableObject {
    
    // MARK: Properties

    var unsuccessfulSignInAttempts: Int = 0

    @Published var errorMessage: String = ""
    @Published var isRefreshing: Bool = false
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var lectures: [CoreDataLecture] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.isRefreshing = false
            }
            sendLecturesToWatch()
        }
    }

    @Published var lectureWeeks: [LectureWeek] = []
    var previousLectureWeeks: [LectureWeek] = []

    private var signInData: SignInData?

    let apiRequest: APIRequest
    let captchaReader: CaptchaReader
    let htmlReader: HTMLReader

    private var session: WCSession?
    
    // MARK: Initialization
    
    init(apiRequest: APIRequest, captchaReader: CaptchaReader, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.captchaReader = captchaReader
        self.htmlReader = htmlReader
        super.init()
        
        activateWatchSession()
        observeRemoveAllLecturesNotification()
    }
    
    // MARK: Methods

    private func observeRemoveAllLecturesNotification() {
        NotificationCenter.default.addObserver(forName: .removeAllLectures, object: nil, queue: nil, using: removeAllLectures)
    }

    private func removeAllLectures(_ notification: Notification) {
        lectures = []
    }
    
    func reloadLectures() {
        fetchLectures(from: persistentContainer.viewContext)
        DispatchQueue.main.async { [weak self] in
            self?.isRefreshing = true
        }
        fetchSchedule()
    }

    private func fetchSchedule() {
        let parameters = ScheduleParameters(fromDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!, toDate: Date())

        apiRequest.getScheduleHtml(parameters: parameters).onDataSuccess({ [weak self] html in
            self?.readLectures(fromHtml: html)
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
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
            onError(error)
        }
    }
    
    func activateWatchSession() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    private func fetchLectures(from context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CoreDataLecture> = CoreDataLecture.fetchRequest()
        
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
    
    func generateLectureDays(from lectures: [CoreDataLecture]?) {
        self.lectures = lectures?.sorted { $0.fromDate < $1.fromDate } ?? []

        let nearestLectureIndex = self.lectures.firstIndex(where: { $0.toDate > Date() }) ?? self.lectures.endIndex

        let futureLectures = Array(self.lectures[nearestLectureIndex...])
        let lectureDays = Array<LectureDay>(lectures: futureLectures)
        self.lectureWeeks = Array<LectureWeek>(lectureDays: lectureDays)

        let previousLectures = Array(self.lectures[..<nearestLectureIndex].reversed())
        let previousLectureDays = Array(Array<LectureDay>(lectures: previousLectures).reversed())
        self.previousLectureWeeks = Array<LectureWeek>(lectureDays: previousLectureDays).reversed()
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

    func onSignIn(html: String, username: String, password: String) {
        fetchSchedule()
    }

    func onError(_ error: Error) {
        apiRequest.getMainHtml().onDataSuccess({ [weak self] html in
            self?.checkIfSignedIn(html: html, error: error)
        }).onError({ [weak self] error in
            self?.onSignInError(error)
        }).make()
    }

    private func checkIfSignedIn(html: String, error: Error) {
        let isSignedIn = htmlReader.isSignedIn(fromHtml: html)
        if isSignedIn {
            print("Already signed in")
            showErrorMessage("")
        } else {
            onSignInError(error)
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

extension ScheduleViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        sendLecturesToWatch()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
}
