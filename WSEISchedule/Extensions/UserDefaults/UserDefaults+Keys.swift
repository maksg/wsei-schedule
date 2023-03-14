//
//  UserDefaults+Keys.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key: String, CaseIterable {
        case student
        case premium
        case cookies
        case gradeSemesters
        case lectureFetchCount
        case lastVersionPromptedForReview
    }

    // MARK: - Properties
    
    var student: Student {
        get {
            return getObject(forKey: Key.student.rawValue) ?? Student()
        }
        set {
            setObject(newValue, forKey: Key.student.rawValue)
        }
    }

    var premium: Bool {
        get {
            bool(forKey: Key.premium.rawValue)
        }
        set {
            set(newValue, forKey: Key.premium.rawValue)
        }
    }

    var cookies: [HTTPCookie] {
        get {
            guard let data = object(forKey: Key.cookies.rawValue) as? Data else { return [] }
            guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else { return [] }
            unarchiver.requiresSecureCoding = false
            return unarchiver.decodeObject(of: NSArray.self, forKey: NSKeyedArchiveRootObjectKey) as? [HTTPCookie] ?? []
        }
        set {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) else { return }
            set(data, forKey: Key.cookies.rawValue)
        }
    }

    var gradeSemesters: [GradeSemester] {
        get {
            return getObject(forKey: Key.gradeSemesters.rawValue) ?? []
        }
        set {
            setObject(newValue, forKey: Key.gradeSemesters.rawValue)
        }
    }

    var lectureFetchCount: Int {
        get {
            integer(forKey: Key.lectureFetchCount.rawValue)
        }
        set {
            set(newValue, forKey: Key.lectureFetchCount.rawValue)
        }
    }

    var lastVersionPromptedForReview: String? {
        get {
            string(forKey: Key.lastVersionPromptedForReview.rawValue)
        }
        set {
            set(newValue, forKey: Key.lastVersionPromptedForReview.rawValue)
        }
    }

    // MARK: - Methods
    
    func signOut() {
        removeObject(forKey: .cookies)
        removeObject(forKey: .student)
        removeObject(forKey: .gradeSemesters)
        removeObject(forKey: .lectureFetchCount)
        removeObject(forKey: .lastVersionPromptedForReview)
    }

    private func removeObject(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }
    
}
