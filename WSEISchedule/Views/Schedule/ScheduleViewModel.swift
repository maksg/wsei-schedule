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
    
    var student: Student { UserDefaults.standard.student }
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
            isRefreshing = false
            sendLecturesToWatch()
        }
    }
    
    @Published var lectureDays: [LectureDay] = []

    private var signInData: SignInData?

    let apiRequest: APIRequest = APIRequest()
    let captchaReader: CaptchaReader = CaptchaReader()
    let htmlReader: HTMLReader = HTMLReader()

    let webView: ScheduleWebView
    private var session: WCSession?
    
    // MARK: Initialization
    
    init(webView: ScheduleWebView) {
        self.webView = webView
        super.init()
        
        webView.loadLectures = loadLectures
        webView.setErrorMessage = setErrorMessage
        
        activateWatchSession()
        observeRemoveAllLecturesNotification()
    }
    
    // MARK: Methods

    private func observeRemoveAllLecturesNotification() {
        NotificationCenter.default.addObserver(forName: .removeAllLectures, object: nil, queue: nil, using: removeAllLectures)
    }

    private func removeAllLectures(_ notification: Notification) {
        lectures = []
        lectureDays = []
    }
    
    func reloadLectures() {
        fetchLectures(from: persistentContainer.viewContext)
        isRefreshing = true

        apiRequest.getSignInPageHtml().onDataSuccess({ [weak self] html in
            self?.handleLoginPageHtml(html)
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
    }

    private func handleLoginPageHtml(_ html: String) {
        do {
            let signInData = try htmlReader.readSignInData(fromHtml: html)
            self.signInData = signInData

            if let captchaSrc = signInData.captchaSrc {
                downloadCaptcha(path: captchaSrc)
            } else {
                signIn(data: signInData)
            }
        } catch {
            print(error)
        }
    }

    private func downloadCaptcha(path: String) {
        apiRequest.downloadCaptcha(path: path).onImageDownloadSuccess({ [weak self] image in
            if let image = image {
                self?.readCaptcha(from: image)
            }
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
    }

    private func readCaptcha(from image: UIImage) {
        captchaReader.readCaptcha(image) { [weak self] result in
            switch result {
            case .success(let captcha):
                guard let data = self?.signInData else { return }
                self?.signIn(data: data, captcha: captcha)
            case .failure(let error):
                print(error)
                self?.reloadLectures()
            }
        }
    }

    private func signIn(data: SignInData, captcha: String? = nil) {
        let signInParameters = SignInParameters(
            usernameId: data.usernameId,
            passwordId: data.passwordId,
            username: student.login,
            password: student.password,
            captcha: captcha
        )

        apiRequest.signIn(parameters: signInParameters).onDataSuccess({ html in
            print(html)
        }).onError({ [weak self] error in
            self?.onError(error)
        }).make()
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
    
    func loadLectures(fromData data: Any?) {
        let managedContext = persistentContainer.viewContext
        deleteLectures(from: managedContext)
        
        let lectures = convertDataToLectureList(data: data)
        generateLectureDays(from: lectures)
        saveLectures(to: managedContext)

        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func setErrorMessage(_ errorMessage: String) {
        self.errorMessage = errorMessage

        guard !errorMessage.isEmpty else { return }
        isRefreshing = false
    }
    
    private func convertDataToLectureList(data: Any?) -> [CoreDataLecture] {
        guard let data = data as? [[String: String]] else { return [] }
        
        let filteredData = data.map { (lecture) -> [String: String] in
            Dictionary(uniqueKeysWithValues: lecture.compactMap({ (key, value) -> (String, String)? in
                let splitValue = value.replacingOccurrences(of: "\n", with: "")
                    .split(separator: ":", maxSplits: 1)
                    .map({ String($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
                guard splitValue.count > 1 else { return nil }
                return (splitValue[0], splitValue[1])
            }))
        }
        
        let managedContext = persistentContainer.viewContext
        return filteredData.map {
            CoreDataLecture(fromDictionary: $0, inContext: managedContext)
        }
    }
    
    func generateLectureDays(from lectures: [CoreDataLecture]?) {
        self.lectures = lectures?.sorted { $0.fromDate < $1.fromDate } ?? []
        
        guard let nearestLectureIndex = self.lectures.firstIndex(where: { $0.toDate > Date() }) else {
            self.lectureDays = []
            return
        }
        
        let futureLectures = self.lectures[nearestLectureIndex..<self.lectures.count]
        self.lectureDays = futureLectures.reduce(into: [LectureDay](), { (lectureDays, lecture) in
            let date = lecture.fromDate.strippedFromTime
            lectureDays[date].lectures += [lecture]
        })
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

    private func onError(_ error: Error) {
        print(error)
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
