//
//  SupportDeveloperProduct.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import StoreKit

struct SupportDeveloperProduct {
    let image: UIImage
    var title: String {
        "\(String.settings(.supportDonate)) \(product.localizedPrice)"
    }
    let product: SKProduct
}
