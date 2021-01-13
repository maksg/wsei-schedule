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
import StoreKit
import WidgetKit

final class SettingsViewModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    var student: Student {
        get {
            UserDefaults.standard.student
        }
        set {
            UserDefaults.standard.student = newValue
        }
    }
    var isSignedIn: Bool { !student.login.isEmpty }
    var signButtonText: String { isSignedIn ? Translation.SignIn.signOut.localized : Translation.SignIn.signIn.localized }
    
    @Published var studentInfoRowViewModel: StudentInfoRowViewModel?
    let webView: ScheduleWebView
    
    @Published var supportDeveloperProducts: [SupportDeveloperProduct] = []
    @Published var showThankYouAlert: Bool = false
    
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
        super.init()
        
        webView.loadStudentInfo = loadStudentInfo
        getInAppPurchases()
        
        if isSignedIn {
            studentInfoRowViewModel = StudentInfoRowViewModel(student: student)
        }
    }
    
    // MARK: Methods
    
    func reloadLectures() {
        webView.login = student.login
        webView.password = student.password
        webView.reload()
    }
    
    private func loadStudentInfo(_ data: Any?) {
        guard let data = data as? [String : String] else { return }
        
        student.name = data["name"] ?? ""
        student.albumNumber = data["number"] ?? ""
        student.courseName = data["course_name"] ?? ""
        student.photoUrl = URL(string: data["photo_url"] ?? "")
        
        studentInfoRowViewModel = StudentInfoRowViewModel(student: student)
    }
    
    private func removeAllLectures() {
        let fetchRequest: NSFetchRequest<CoreDataLecture> = CoreDataLecture.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            let lectures = try context.fetch(fetchRequest)
            lectures.forEach(context.delete)
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func getInAppPurchases() {
        let productIdentifiers = (1...4).map { "supportDeveloper\($0)" }
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
        SKPaymentQueue.default().add(self)
    }
    
    func buy(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func signOut() {
        studentInfoRowViewModel = nil
        removeAllLectures()
        URLCache.shared.removeAllCachedResponses()

        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }

        UserDefaults.standard.signOut()
    }
    
}

// MARK: SKProductsRequestDelegate

extension SettingsViewModel: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        let cashSymbols: [String] = ["💵", "💴", "💶", "💷"]
        let prices = products.map(\.localizedPrice)
        let titles = zip(cashSymbols, prices).map { (symbol, price) in
            "\(symbol)  \(Translation.Settings.Support.donate.localized) \(price)"
        }
        supportDeveloperProducts = zip(titles, products).map(SupportDeveloperProduct.init)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
    }
    
}

// MARK: SKPaymentTransactionObserver

extension SettingsViewModel: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions where transaction.transactionState == .purchased {
            SKPaymentQueue.default().finishTransaction(transaction)
            showThankYouAlert = true
        }
    }
    
}

