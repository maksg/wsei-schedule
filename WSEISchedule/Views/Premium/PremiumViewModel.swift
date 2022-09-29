//
//  PremiumViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 29/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import StoreKit

final class PremiumViewModel: NSObject, ObservableObject {

    // MARK: Properties

    @Published private var premiumProduct: SKProduct?

    var price: String {
        premiumProduct?.localizedPrice ?? "---"
    }

    // MARK: Initialization

    override init() {
        super.init()
        fetchProduct()
    }

    // MARK: Methods

    private func fetchProduct() {
        let productsRequest = SKProductsRequest(productIdentifiers: ["premium"])
        productsRequest.delegate = self
        productsRequest.start()
        SKPaymentQueue.default().add(self)
    }

    func buyPremium() {
        guard let premiumProduct else { return }
        let payment = SKPayment(product: premiumProduct)
        SKPaymentQueue.default().add(payment)
    }

}

// MARK: SKProductsRequestDelegate

extension PremiumViewModel: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.premiumProduct = response.products.first
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
    }

}

// MARK: SKPaymentTransactionObserver

extension PremiumViewModel: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions where transaction.transactionState == .purchased && transaction.payment.productIdentifier == "premium" {
            SKPaymentQueue.default().finishTransaction(transaction)
            UserDefaults.standard.premium = true
        }
    }

}
