//
//  CodableLecture.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 11/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

@objc(CodableLecture)
final class CodableLecture: NSObject, NSCoding, Lecture {
    
    var lecturer: String
    var classroom: String
    var fromDate: Date
    var toDate: Date
    var code: String
    var subject: String
    
    func encode(with coder: NSCoder) {
        coder.encode(fromDate, forKey: "fromDate")
        coder.encode(toDate, forKey: "toDate")
        coder.encode(subject, forKey: "subject")
        coder.encode(classroom, forKey: "classroom")
        coder.encode(lecturer, forKey: "lecturer")
        coder.encode(code, forKey: "code")
    }
    
    init?(coder: NSCoder) {
        fromDate = coder.decodeObject(forKey: "fromDate") as? Date ?? Date()
        toDate = coder.decodeObject(forKey: "toDate") as? Date ?? Date()
        subject = coder.decodeObject(forKey: "subject") as? String ?? ""
        classroom = coder.decodeObject(forKey: "classroom") as? String ?? ""
        lecturer = coder.decodeObject(forKey: "lecturer") as? String ?? ""
        code = coder.decodeObject(forKey: "code") as? String ?? ""
    }
    
    init(lecturer: String, classroom: String, fromDate: Date, toDate: Date, code: String, subject: String) {
        self.lecturer = lecturer
        self.classroom = classroom
        self.fromDate = fromDate
        self.toDate = toDate
        self.code = code
        self.subject = subject
    }
    
    init(lecture: Lecture) {
        self.lecturer = lecture.lecturer
        self.classroom = lecture.classroom
        self.fromDate = lecture.fromDate
        self.toDate = lecture.toDate
        self.code = lecture.code
        self.subject = lecture.subject
    }
    
}

