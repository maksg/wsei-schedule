//
//  SettingsViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Combine
import SwiftUI
import CoreData

final class SettingsViewModel: ObservableObject {
    
    // MARK: Properties
    
    var login: String { UserDefaults.standard.login }
    var password: String { UserDefaults.standard.password }
    var isSignedIn: Bool { !login.isEmpty }
    var signButtonText: String { isSignedIn ? Translation.SignIn.signOut.localized : Translation.SignIn.signIn.localized }
    
    @Published var studentInfoRowViewModel: StudentInfoRowViewModel?
    var webView: ScheduleWebView
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    init(webView: ScheduleWebView) {
        self.webView = webView
        webView.loadStudentInfo = loadStudentInfo
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        webView.login = login
        webView.password = password
        webView.reload()
    }
    
    private func loadStudentInfo(_ data: Any?) {
        guard let data = data as? [String : String] else { return }
        let name = data["name"] ?? ""
        let number = data["number"] ?? ""
        let courseName = data["course_name"] ?? ""
        let photoUrl = URL(string: data["photo_url"] ?? "")
        studentInfoRowViewModel = StudentInfoRowViewModel(name: name, number: number, courseName: courseName, photoUrl: photoUrl)
    }
    
    private func removeAllLectures() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lecture")
        let context = persistentContainer.viewContext
        
        do {
            let lectures = try context.fetch(fetchRequest) as? [Lecture]
            lectures?.forEach { lecture in
                context.delete(lecture)
            }
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func signOut() {
        studentInfoRowViewModel = nil
        removeAllLectures()
        URLCache.shared.removeAllCachedResponses()
        UserDefaults.standard.signOut()
    }
    
}
