//
//  SignInViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {
    
    var login: String {
        get {
            UserDefaults.standard.login
        }
        set {
            objectWillChange.send()
            UserDefaults.standard.login = newValue
        }
    }
    
    var password: String {
        get {
            UserDefaults.standard.password
        }
        set {
            objectWillChange.send()
            UserDefaults.standard.password = newValue
        }
    }
    
    var loginPlaceholder: String { Translation.SignIn.login.localized }
    var passwordPlaceholder: String { Translation.SignIn.password.localized }
    
}

