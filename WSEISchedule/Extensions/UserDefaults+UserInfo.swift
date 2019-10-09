//
//  UserDefaults+UserInfo.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var login: String {
        get {
            string(forKey: "login") ?? ""
        }
        set {
            set(newValue, forKey: "login")
        }
    }
    
    var password: String {
        get {
            string(forKey: "password") ?? ""
        }
        set {
            set(newValue, forKey: "password")
        }
    }
    
    func signOut() {
        removeObject(forKey: "login")
        removeObject(forKey: "password")
    }
    
}
