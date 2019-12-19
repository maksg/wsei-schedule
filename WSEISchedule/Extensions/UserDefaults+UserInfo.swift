//
//  UserDefaults+UserInfo.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private enum Key: String {
        case login
        case password
    }
    
    var login: String {
        get {
            string(forKey: Key.login.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.login.rawValue)
        }
    }
    
    var password: String {
        get {
            string(forKey: Key.password.rawValue) ?? ""
        }
        set {
            set(newValue, forKey: Key.password.rawValue)
        }
    }
    
    func signOut() {
        removeObject(forKey: Key.login.rawValue)
        removeObject(forKey: Key.password.rawValue)
    }
    
}
