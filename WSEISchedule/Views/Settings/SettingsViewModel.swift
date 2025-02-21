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
    
    @DispatchMainPublished var studentInfoRowViewModel: StudentInfoRowViewModel = StudentInfoRowViewModel(student: Student())
    @DispatchMainPublished var supportDeveloperProducts: [SupportDeveloperProduct] = []
    @DispatchMainPublished var showThankYouAlert: Bool = false
    @DispatchMainPublished var isRefreshing: Bool = false

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSSharedPersistentContainer(name: "Lectures")
        container.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return container
    }()

    var checkIfIsSignedIn: ((Error) -> Void)?
    var startSigningIn: (() -> Void)?

    let apiRequest: APIRequestable
    let htmlReader: HTMLReader

    // MARK: - Initialization

    init(apiRequest: APIRequestable, htmlReader: HTMLReader) {
        self.apiRequest = apiRequest
        self.htmlReader = htmlReader
        super.init()

        setupStudentInfoRow()
        getInAppPurchases()
    }
    
    // MARK: - Methods

    func loadStudentInfo() async {
        guard isSignedIn && !isRefreshing else { return }

        if studentInfoRowViewModel.name.isEmpty {
            isRefreshing = true
        }

        do {
            let html = try await apiRequest.getStudentInfoHtml()
            readStudentInfo(fromHtml: html)
        } catch {
            showError(error)
        }
    }

    private func readStudentInfo(fromHtml html: String) {
        guard isSignedIn else {
            isRefreshing = false
            return
        }
        
        do {
            student = try htmlReader.readStudentInfo(fromHtml: html)
            showError(nil)
        } catch {
            checkIfIsSignedIn?(error)
        }

        setupStudentInfoRow()

        isRefreshing = false
    }

    private func setupStudentInfoRow() {
        studentInfoRowViewModel = StudentInfoRowViewModel(student: student)
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
        apiRequest.clearCache()
        UserDefaults.standard.signOut()
        deleteAllLectures()
        setupStudentInfoRow()

        WidgetCenter.shared.reloadAllTimelines()
    }

    private func deleteAllLectures() {
        NotificationCenter.default.post(name: .deleteAllLectures, object: nil)
    }
    
}

extension SettingsViewModel: SignInable {

    func showError(_ error: Error?) {
        print(error?.localizedDescription ?? "")
        self.isRefreshing = false
    }

}

// MARK: - SKProductsRequestDelegate

extension SettingsViewModel: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        let cashSymbols: [UIImage] = ["💵", "💴", "💶", "💷"].compactMap(\.image)
        supportDeveloperProducts = zip(cashSymbols, products).map(SupportDeveloperProduct.init)
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

