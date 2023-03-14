//
//  StudentInfoRowViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class StudentInfoRowViewModel {

    // MARK: - Properties
    
    let name: String
    let number: String
    let courseName: String
    let photoUrl: URL?
    let cacheRequest: URLRequest

    // MARK: - Initialization
    
    convenience init(student: Student) {
        self.init(name: student.name, number: student.albumNumber, courseName: student.courseName, photoUrl: student.photoUrl)
    }
    
    init(name: String, number: String, courseName: String, photoUrl: URL?) {
        self.name = name
        self.number = number
        self.courseName = courseName

        #if MOCK
        self.photoUrl = nil
        #else
        self.photoUrl = photoUrl
        #endif

        self.cacheRequest = URLRequest(url: URL(string: "http://dziekanat.wsei.edu.pl/photo")!)
    }
    
}
