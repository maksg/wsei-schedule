//
//  ExtensionDelegate.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    // MARK: - Properties
    
    private var lectures: [Lecture] = []
    var lectureDays: [LectureDay] = [] {
        didSet {
            NotificationCenter.default.post(name: .didReloadLectures, object: nil)
        }
    }
    private let session: WCSession = .default
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    // MARK: - Methods
    
    func reloadLectures() {
        let context = session.receivedApplicationContext
        fetchLectures(from: context)
    }
    
    private func fetchLectures(from context: [String : Any]) {
        guard let data = context["lectures"] as? Data, let lectures = Array(data: data) else { return }
        generateLectureDays(from: lectures)
    }
    
    func generateLectureDays(from unsortedLectures: [Lecture]?) {
        lectures = unsortedLectures?.sorted { $0.fromDate < $1.fromDate } ?? []
        
        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else {
            lectureDays = []
            return
        }
        
        let futureLectures = lectures[nearestLectureIndex...]
        lectureDays = Array(lectures: futureLectures)
    }
    
    // MARK: - Delegate

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillEnterForeground() {
        reloadLectures()
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        reloadLectures()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchLectures(from: applicationContext)
        }
    }
    
}
