//
//  ContentViewModel.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import CoreData
import WatchConnectivity

final class ContentViewModel: NSObject, BindableObject {
    let didChange = PassthroughSubject<ContentViewModel, Never>()
    
    // MARK: Properties
    
    var albumNumber: String {
        UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
    }
    
    private var lectures: [CodableLecture] = []
    var lectureDays: [LectureDay] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    private let session: WCSession = .default
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
        
        NotificationCenter.default.addObserver(forName: .NSExtensionHostDidBecomeActive, object: nil, queue: .main) { [weak self] _ in
            self?.reloadLectures()
        }
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        let context = session.receivedApplicationContext
        fetchLectures(from: context)
    }
    
    private func fetchLectures(from context: [String : Any]) {
        guard let data = context["lectures"] as? Data else { return }
        do {
            lectures = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [CodableLecture] ?? []
        } catch {
            print(error)
        }
        generateLectureDays()
    }
    
    private func generateLectureDays() {
        lectures = Array(Set(lectures))
        lectures.sort { $0.fromDate < $1.fromDate }
        
        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else { return }
        let futureLectures = lectures[nearestLectureIndex..<lectures.count]
        lectureDays = futureLectures.reduce(into: [LectureDay](), { (lectureDays, lecture) in
            let date = lecture.fromDate.strippedFromTime
            lectureDays[date].lectures += [lecture]
        })
    }
    
}

extension ContentViewModel: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchLectures(from: applicationContext)
        }
    }
    
}
