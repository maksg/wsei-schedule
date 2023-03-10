//
//  ContentViewModel.swift
//  WSEIScheduleWatch
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import CoreData
import WatchConnectivity

final class ContentViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @DispatchMainPublished var lectureDays: [LectureDay] = []

    private var lectures: [Lecture] = []
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

    func generateLectureDays(from unsortedLectures: [Lecture]) {
        lectures = unsortedLectures.sorted { $0.fromDate < $1.fromDate }

        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else {
            lectureDays = []
            return
        }

        let futureLectures = lectures[nearestLectureIndex...]
        lectureDays = Array(lectures: futureLectures)
    }
    
}

extension ContentViewModel: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        reloadLectures()
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        fetchLectures(from: applicationContext)
    }

}
