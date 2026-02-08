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
    let photoSource: String?
    let cacheRequest: URLRequest

    var photoUrl: URL? {
        URL(string: "https://dziekanat.wsei.edu.pl\(photoSource ?? "/")")
    }

    var photoData: Data? {
        guard var photoSource, let base64Start = photoSource.range(of: "base64,") else { return nil }
        photoSource.removeSubrange(..<base64Start.upperBound)
        return Data(base64Encoded: photoSource)
    }

    // MARK: - Initialization
    
    convenience init(student: Student) {
        self.init(name: student.name, number: student.albumNumber, courseName: student.courseName, photoSource: student.photoSource)
    }
    
    init(name: String, number: String, courseName: String, photoSource: String?) {
        self.name = name
        self.number = number
        self.courseName = courseName

        #if MOCK
        self.photoSource = nil
        #else
        self.photoSource = photoSource
        #endif

        self.cacheRequest = URLRequest(url: URL(string: "http://dziekanat.wsei.edu.pl/photo")!)
    }
    
}
