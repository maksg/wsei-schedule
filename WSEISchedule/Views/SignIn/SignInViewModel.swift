//
//  SignInViewModel.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 03/10/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {

    // MARK: - Properties

    var isSigningIn: Bool = false
    var startSigningIn: (() -> Void)?

    // MARK: - Methods

    func signIn() {
        startSigningIn?()
    }
    
}
