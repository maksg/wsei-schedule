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
    
    var lectureDays: [LectureDay] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(forName: .NSExtensionHostDidBecomeActive, object: nil, queue: .main) { [weak self] _ in
            self?.reloadLectures()
        }
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        lectureDays = delegate?.lectureDays ?? []
    }
    
}
