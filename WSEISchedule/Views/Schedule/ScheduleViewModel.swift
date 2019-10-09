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

final class ScheduleViewModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    var login: String { UserDefaults.standard.login }
    var password: String { UserDefaults.standard.password }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var lectures: [Lecture] = [] {
        didSet {
            sendLecturesToWatch()
        }
    }
    
    @Published var lectureDays: [LectureDay] = []
    
    private var webView: ScheduleWebView
    private var session: WCSession?
    
    // MARK: Initialization
    
    override init() {
        webView = ScheduleWebView()
        super.init()
        
        webView.loadLectures = loadLectures
        
        activateWatchSession()
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        fetchLectures(from: persistentContainer.viewContext)
        
        webView.login = login
        webView.password = password
        webView.reload()
    }
    
    func activateWatchSession() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    private func fetchLectures(from context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        
        do {
            let lectures = try context.fetch(fetchRequest) as? [Lecture]
            generateLectureDays(from: lectures)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func sendLecturesToWatch() {
        do {
            let codableLectures = lectures.map { CodableLecture(lecture: $0) }
            let data = try NSKeyedArchiver.archivedData(withRootObject: codableLectures, requiringSecureCoding: false)
            let context = ["lectures" : data]
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
    }
    
    private func convertDataToLectureList(data: Any?) -> [Lecture] {
        guard let data = data as? [[String : String]] else { return [] }
        
        let filteredData = data.map { (lecture) -> [String : String] in
            Dictionary(uniqueKeysWithValues: lecture.compactMap({ (key, value) -> (String, String)? in
                let splitValue = value.replacingOccurrences(of: "\n", with: "")
                    .split(separator: ":", maxSplits: 1)
                    .map({ String($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
                guard splitValue.count > 1 else { return nil }
                return (splitValue[0], splitValue[1])
            }))
        }
        
        let managedContext = persistentContainer.viewContext
        return filteredData.map { Lecture(fromDictionary: $0, inContext: managedContext) }
    }
    
    func generateLectureDays(from lectures: [Lecture]?) {
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
        lectures.forEach { lecture in
            context.delete(lecture)
        }
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

extension ScheduleViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        sendLecturesToWatch()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
}
