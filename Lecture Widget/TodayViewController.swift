//
//  TodayViewController.swift
//  Lecture Widget
//
//  Created by Maksymilian Galas on 17/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet private weak var noLecturesTodayLabel: UILabel!
    @IBOutlet private weak var todayLectureStackView: UIStackView!
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var classroomLabel: UILabel!
    @IBOutlet private weak var lecturerLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    
    @IBOutlet private weak var nextLabel: UILabel!
    
    @IBOutlet private weak var noNextLecturesLabel: UILabel!
    @IBOutlet private weak var nextLectureStackView: UIStackView!
    @IBOutlet private weak var nextSubjectLabel: UILabel!
    @IBOutlet private weak var nextTimeLabel: UILabel!
    @IBOutlet private weak var nextClassroomLabel: UILabel!
    
    private var lectures: [Lecture] = []
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noLecturesTodayLabel.text = Translation.Widget.noLecturesToday.localized
        noNextLecturesLabel.text = Translation.Widget.noNextLectures.localized
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        fetchLectures(from: persistentContainer.viewContext)
        
        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else {
            setupNearestLecture(nil)
            setupNextLecture(nil)
            completionHandler(.noData)
            return
        }
        
        let nearestLecture = lectures[nearestLectureIndex]
        if nearestLecture.fromDate.isToday {
            setupNearestLecture(nearestLecture)
            
            if nearestLectureIndex < lectures.endIndex {
                let nextLecture = lectures[nearestLectureIndex+1]
                setupNextLecture(nextLecture)
            } else {
                setupNextLecture(nil)
            }
        } else {
            setupNearestLecture(nil)
            setupNextLecture(nearestLecture)
        }
        
        completionHandler(.newData)
    }
    
    private func setupNearestLecture(_ lecture: Lecture?) {
        guard let lecture = lecture else {
            todayLectureStackView.isHidden = true
            noLecturesTodayLabel.isHidden = false
            return
        }
        
        todayLectureStackView.isHidden = false
        noLecturesTodayLabel.isHidden = true
        
        subjectLabel.text = lecture.subject
        timeLabel.text = "\(lecture.fromDate.shortHour) - \(lecture.toDate.shortHour)"
        classroomLabel.text = lecture.classroom
        lecturerLabel.text = lecture.lecturer
        codeLabel.text = lecture.code
    }
    
    private func setupNextLecture(_ lecture: Lecture?) {
        let nextText = Translation.Widget.next.localized
        guard let lecture = lecture else {
            nextLectureStackView.isHidden = true
            noNextLecturesLabel.isHidden = false
            nextLabel.text = nextText.uppercased()
            return
        }
        
        nextLectureStackView.isHidden = false
        noNextLecturesLabel.isHidden = true
        
        let date = lecture.fromDate
        let dayText: String
        
        if date.isToday {
            dayText = Translation.Schedule.today.localized
        } else if date.isTomorrow {
            dayText = Translation.Schedule.tomorrow.localized
        } else {
            dayText = date.formattedDay
        }
        
        nextLabel.text = "\(nextText) - \(dayText)".uppercased()
        
        nextSubjectLabel.text = lecture.subject
        nextTimeLabel.text = "\(lecture.fromDate.shortHour) - \(lecture.toDate.shortHour)"
        nextClassroomLabel.text = lecture.classroom
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
    private func fetchLectures(from context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        
        do {
            let results = try context.fetch(fetchRequest) as? [Lecture]
            self.lectures = results?.sorted(by: { $0.fromDate < $1.fromDate }) ?? []
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
}
