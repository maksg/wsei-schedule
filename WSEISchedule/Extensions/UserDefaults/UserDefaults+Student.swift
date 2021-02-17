//
//  UserDefaults+Student.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private enum Key: String, CaseIterable {
        case login
        case password
        case name
        case albumNumber
        case courseName
        case photoUrl
        case student
    }

    // MARK: Properties
    
    var student: Student {
        get {
            if let student: Student = getObject(forKey: Key.student.rawValue) {
                return student
            }

            let login = self.login
            if !login.isEmpty {
                let student = Student(login: login, password: password, name: name, albumNumber: albumNumber, courseName: courseName, photoUrl: photoUrl)
                signOut()
                self.student = student
                return student
            }

            return Student(login: "", password: "", name: "", albumNumber: "", courseName: "", photoUrl: nil)
        }
        set {
            setObject(newValue, forKey: Key.student.rawValue)
        }
    }
    
    private var login: String {
        string(forKey: Key.login.rawValue) ?? ""
    }
    
    private var password: String {
        string(forKey: Key.password.rawValue) ?? ""
    }
    
    private var name: String {
        string(forKey: Key.name.rawValue) ?? ""
    }
    
    private var albumNumber: String {
        string(forKey: Key.albumNumber.rawValue) ?? ""
    }
    
    private var courseName: String {
        string(forKey: Key.courseName.rawValue) ?? ""
    }
    
    private var photoUrl: URL? {
        URL(string: string(forKey: Key.photoUrl.rawValue) ?? "")
    }

    // MARK: Methods
    
    func signOut() {
        Key.allCases.forEach { key in
            removeObject(forKey: key.rawValue)
        }
    }
    
}
