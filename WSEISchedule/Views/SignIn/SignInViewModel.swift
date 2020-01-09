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
            UserDefaults.standard.student.login
        }
        set {
            objectWillChange.send()
            UserDefaults.standard.student.login = newValue
        }
    }
    
    var password: String {
        get {
            UserDefaults.standard.student.password
        }
        set {
            objectWillChange.send()
            UserDefaults.standard.student.password = newValue
        }
    }
    
    var loginPlaceholder: String { Translation.SignIn.login.localized }
    var passwordPlaceholder: String { Translation.SignIn.password.localized }
    
}

