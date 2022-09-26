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
        case student
    }

    // MARK: Properties
    
    var student: Student {
        get {
            if let student: Student = getObject(forKey: Key.student.rawValue) {
                return student
            }
            return Student(name: "", albumNumber: "", courseName: "", photoUrl: nil)
        }
        set {
            setObject(newValue, forKey: Key.student.rawValue)
        }
    }

    // MARK: Methods
    
    func signOut() {
        Key.allCases.forEach { key in
            removeObject(forKey: key.rawValue)
        }
    }
    
}
