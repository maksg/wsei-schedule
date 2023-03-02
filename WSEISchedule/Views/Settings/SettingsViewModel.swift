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
    
    // MARK: - Properties
    
    var student: Student {
        get {
            UserDefaults.standard.student
        }
        set {
            UserDefaults.standard.student = newValue
        }
    }
    
    @Published var studentInfoRowViewModel: StudentInfoRowViewModel?
    
    @Published var supportDeveloperProducts: [SupportDeveloperProduct] = []
    @Published var showThankYouAlert: Bool = false
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let error = error as NSError? else { return }
            print("Unresolved error \(error), \(error.userInfo)")
        })
        return container
    }()

    let apiRequest: APIRequest
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequest, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()
        
        getInAppPurchases()
    }
    
    // MARK: - Methods

    func loadStudentInfo() async {
        guard HTTPCookieStorage.shared.cookies?.isEmpty == false else {
            return
        }

        setupStudentInfoRow()

        do {
            let html = try await apiRequest.getMainHtml().make()
            readStudentInfo(fromHtml: html)
        } catch {
            onError(error)
        }
    }

    private func readStudentInfo(fromHtml html: String) {
        do {
            student = try htmlReader.readStudentInfo(fromHtml: html)
            resetErrors()
        } catch {
            onError(error)
        }

        setupStudentInfoRow()
    }

    private func setupStudentInfoRow() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.studentInfoRowViewModel = StudentInfoRowViewModel(student: self.student)
        }
    }
    
    private func removeAllLectures() {
        let fetchRequest: NSFetchRequest<CoreDataLecture> = CoreDataLecture.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            let lectures = try context.fetch(fetchRequest)
            lectures.forEach(context.delete)
            try context.save()

            NotificationCenter.default.post(name: .removeAllLectures, object: nil)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    private func getInAppPurchases() {
        let productIdentifiers = (1...4).map({ "supportDeveloper\($0)" })
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
        DispatchQueue.main.async { [weak self] in
            self?.studentInfoRowViewModel = nil
        }
        removeAllLectures()
        apiRequest.clearCache()

        WidgetCenter.shared.reloadAllTimelines()

        UserDefaults.standard.signOut()
    }
    
}

extension SettingsViewModel: SignInable {

    func onSignIn() {
        Task {
            await loadStudentInfo()
        }
    }

    func showErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }

}

// MARK: - SKProductsRequestDelegate

extension SettingsViewModel: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        let cashSymbols: [UIImage] = ["💵", "💴", "💶", "💷"].compactMap(\.image)

        DispatchQueue.main.async { [weak self] in
            self?.supportDeveloperProducts = zip(cashSymbols, products).map(SupportDeveloperProduct.init)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
    }
    
}

// MARK: - SKPaymentTransactionObserver

extension SettingsViewModel: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions where transaction.transactionState == .purchased && transaction.payment.productIdentifier.contains("supportDeveloper") {
            SKPaymentQueue.default().finishTransaction(transaction)
            showThankYouAlert = true
        }
    }
    
}

