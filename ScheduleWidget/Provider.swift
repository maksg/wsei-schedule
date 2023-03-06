//
//  Provider.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import WidgetKit
import CoreData

struct Provider: TimelineProvider {
    private let persistentContainer: NSPersistentContainer

    init() {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            print("Unresolved error \(error), \(error.userInfo)")
        }
        persistentContainer = container
    }

    private func fetchLectures(from context: NSManagedObjectContext) -> [Lecture] {
        let fetchRequest = CoreDataLecture.fetchRequest()

        do {
            let lectures = try context.fetch(fetchRequest)
            return lectures.compactMap(Lecture.init).sorted(by: { $0.fromDate < $1.fromDate })
        } catch let error as NSError {
            print(error.debugDescription)
            return []
        }
    }

    var nearestLectures: (todays: Lecture?, next: Lecture?) {
        let lectures = fetchLectures(from: persistentContainer.viewContext)

        guard let nearestLectureIndex = lectures.firstIndex(where: { $0.toDate > Date() }) else {
            return (nil, nil)
        }

        let nearestLecture = lectures[nearestLectureIndex]
        if nearestLecture.fromDate.isToday {
            if nearestLectureIndex < lectures.endIndex {
                return (nearestLecture, lectures[nearestLectureIndex+1])
            } else {
                return (nearestLecture, nil)
            }
        } else {
            return (nil, nearestLecture)
        }
    }

    func placeholder(in context: Context) -> LectureEntry {
        LectureEntry(date: Date(), todaysLecture: MockData.lecture, nextLecture: MockData.lecture)
    }

    func getSnapshot(in context: Context, completion: @escaping (LectureEntry) -> ()) {
        let entry = LectureEntry(date: Date(), todaysLecture: nearestLectures.todays, nextLecture: nearestLectures.next)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LectureEntry>) -> ()) {
        let lectures = nearestLectures

        let entryDate: Date
        if let todaysLecture = lectures.todays {
            if todaysLecture.fromDate > Date() {
                entryDate = todaysLecture.fromDate
            } else {
                entryDate = todaysLecture.toDate
            }
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            entryDate = Calendar.current.startOfDay(for: tomorrow)
        }

        let entry = LectureEntry(date: entryDate, todaysLecture: lectures.todays, nextLecture: lectures.next)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
