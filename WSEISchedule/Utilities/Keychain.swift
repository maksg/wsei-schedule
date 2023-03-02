//
//  Keychain.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 26/09/2022.
//  Copyright © 2022 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import Security

final class Keychain {

    class func clean() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        SecItemDelete(query)
    }

}
