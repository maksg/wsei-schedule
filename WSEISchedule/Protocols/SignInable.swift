//
//  SignInable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 22/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit

protocol SignInable {
    var checkIfIsSignedIn: ((Error) -> Void)? { get set }
    func showError(_ error: Error?)
}

extension SignInable {

    var isSignedIn: Bool {
        HTTPCookieStorage.shared.cookies?.isEmpty == false
    }

}
