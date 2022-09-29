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
    static let standard = Keychain()

    func save(username: String, password: String) {
        let keychainItemQuery = [
            kSecValueData: password.data(using: .utf8)!,
            kSecAttrAccount: username,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(keychainItemQuery, nil)
        if status != errSecSuccess {
            let credentials = retrieveUsernameAndPassword()
            if credentials.username.isEmpty || credentials.password.isEmpty {
                signOut()
                save(username: username, password: password)
            }
        }
    }

    func retrieveUsernameAndPassword() -> (username: String, password: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        let _ = SecItemCopyMatching(query, &result)
        let dictionary = result as? NSDictionary

        guard
            let username = dictionary?[kSecAttrAccount] as? String,
            let passwordData = dictionary?[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else { return ("", "") }

        return (username, password)
    }

    func signOut() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        SecItemDelete(query as CFDictionary)
    }
}
