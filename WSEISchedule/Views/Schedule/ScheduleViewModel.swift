//
//  ScheduleViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import WebKit
import CoreData

final class ScheduleViewModel: ViewModel {
    
    // MARK: Properties
    
    var albumNumber: String {
        "10951"
//        UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
    }
    
    var title: String {
        Tab.schedule.title
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var lectures: [Lecture] = []
    var tmpLectures: [Lecture] = []
    var scheduleCellViewModels: [Date : [ScheduleCellViewModel]] = [:]
    
    private var webView: ScheduleWebView
    
    // MARK: Initialization
    
    init() {
        webView = ScheduleWebView()
        webView.addLectures = addLectures(fromData:)
        webView.finishLoadingLectures = finishLoadingLectures
        webView.albumNumber = albumNumber
        webView.reload()
        fetchLectures(from: persistentContainer.viewContext)
    }
    
    // MARK: Methods
    
    private func fetchLectures(from context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let lectures = results as? [Lecture] else { return }
            self.lectures = lectures
            generateScheduleCellViewModels()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func addLectures(fromData data: Any?) {
        let lectures = convertDataToLectureList(data: data)
        self.tmpLectures += lectures
    }
    
    func finishLoadingLectures() {
        let managedContext = persistentContainer.viewContext
        deleteLectures(from: managedContext)
        
        lectures = tmpLectures
        tmpLectures = []
        
        generateScheduleCellViewModels()
        saveLectures(to: managedContext)
    }
    
    private func convertDataToLectureList(data: Any?) -> [Lecture] {
        guard let data = data as? [[String : String]] else { return [] }
        
        let filteredData = data.map { (lecture) -> [String : String] in
            Dictionary(uniqueKeysWithValues: lecture.compactMap({ (key, value) -> (String, String)? in
                let splitValue = value.split(separator: ":", maxSplits: 1)
                guard splitValue.count > 0 else { return nil }
                return (String(splitValue[0].trimmingCharacters(in: .whitespacesAndNewlines)), String(splitValue[1].trimmingCharacters(in: .whitespacesAndNewlines)))
            }))
        }
        
        let managedContext = persistentContainer.viewContext
        return filteredData.map { Lecture(fromDictionary: $0, inContext: managedContext) }
    }
    
    func generateScheduleCellViewModels() {
        lectures = Array(Set(lectures))
        lectures.sort { $0.fromDate < $1.fromDate }
        
        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else { return }
        let futureLectures = lectures[nearestLectureIndex..<lectures.count]
        scheduleCellViewModels = futureLectures.reduce(into: [Date : [ScheduleCellViewModel]]()) {
            let viewModel = ScheduleCellViewModel(lecture: $1)
            let date = $1.fromDate.strippedFromTime
            if $0[date] == nil {
                $0[date] = [viewModel]
            } else {
                $0[date]! += [viewModel]
            }
        }
    }
    
    private func deleteLectures(from context: NSManagedObjectContext) {
        for lecture in lectures {
            context.delete(lecture)
        }
    }
    
    private func saveLectures(to context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}
