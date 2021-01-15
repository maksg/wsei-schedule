//
//  SignInViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {

    // MARK: Properties
    
    var login: String = ""
    var password: String = ""
    
    var loginPlaceholder: String { Translation.SignIn.login.localized }
    var passwordPlaceholder: String { Translation.SignIn.password.localized }

    // MARK: Methods

    func signIn(onSuccess: (() -> Void)?) {
        UserDefaults.standard.student.login = login
        UserDefaults.standard.student.password = password
        onSuccess?()
    }
    
}

