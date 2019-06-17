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
    
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var classroomLabel: UILabel!
    @IBOutlet private weak var lecturerLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    
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
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        fetchLectures(from: persistentContainer.viewContext)
        
        guard let nearestLecture = lectures.first(where: { $0.toDate > Date() }) else {
            completionHandler(.noData)
            return
        }
        
        subjectLabel.text = nearestLecture.subject
        timeLabel.text = "\(nearestLecture.fromDate.shortHour) - \(nearestLecture.toDate.shortHour)"
        classroomLabel.text = nearestLecture.classroom
        lecturerLabel.text = nearestLecture.lecturer
        codeLabel.text = nearestLecture.code
        
        completionHandler(.newData)
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
