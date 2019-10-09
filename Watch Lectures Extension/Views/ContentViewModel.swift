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

final class ContentViewModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    @Published var lectureDays: [LectureDay] = []
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        let name = Notification.Name(rawValue: "ReloadedLectures")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
            self?.reloadLectures()
        }
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        lectureDays = delegate?.lectureDays ?? []
    }
    
}
