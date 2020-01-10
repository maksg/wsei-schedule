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
    }
    
    var student: Student {
        get {
            Student(login: login, password: password, name: name, albumNumber: albumNumber, courseName: courseName, photoUrl: photoUrl)
        }
        set {
            login = newValue.login
            password = newValue.password
            name = newValue.name
            albumNumber = newValue.albumNumber
            courseName = newValue.courseName
            photoUrl = newValue.photoUrl
        }
    }
    
    private var login: String {
        get {
            string(forKey: Key.login.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.login.rawValue)
        }
    }
    
    private var password: String {
        get {
            string(forKey: Key.password.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.password.rawValue)
        }
    }
    
    private var name: String {
        get {
            string(forKey: Key.name.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.name.rawValue)
        }
    }
    
    private var albumNumber: String {
        get {
            string(forKey: Key.albumNumber.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.albumNumber.rawValue)
        }
    }
    
    private var courseName: String {
        get {
            string(forKey: Key.courseName.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.courseName.rawValue)
        }
    }
    
    private var photoUrl: URL? {
        get {
            URL(string: string(forKey: Key.photoUrl.rawValue) ?? "")
        }
        set {
            set(newValue?.absoluteString, forKey: Key.photoUrl.rawValue)
        }
    }
    
    func signOut() {
        Key.allCases.forEach { key in
            removeObject(forKey: key.rawValue)
        }
    }
    
}
