//
//  ScheduleViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation
import CoreData

class ScheduleViewModel: ViewModel {
    
    // MARK: Properties
    
    var scheduleURL: URL {
        return URL(string: "https://estudent.wsei.edu.pl/SG/PublicDesktop.aspx?fileShareToken=95-88-6B-EB-B0-75-96-FB-A9-7C-AE-D7-5C-DB-90-49")!
    }
    
    var albumNumber: String {
        return UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
    }
    
    var title: String {
        return Translation.Schedule.title.localized
    }
    
    var lectures: [Lecture]
    var tmpLectures: [Lecture]
    var scheduleCellViewModels: [Date : [ScheduleCellViewModel]]
    
    let persistentContainer: NSPersistentContainer
    
    // MARK: Initialization
    
    init(persistentContainer: NSPersistentContainer) {
        self.lectures = []
        self.tmpLectures = []
        self.scheduleCellViewModels = [:]
        self.persistentContainer = persistentContainer
        
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
    
    private func generateScheduleCellViewModels() {
        lectures.sort { $0.fromDate < $1.fromDate }
        scheduleCellViewModels = lectures.reduce(into: [Date : [ScheduleCellViewModel]]()) {
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
