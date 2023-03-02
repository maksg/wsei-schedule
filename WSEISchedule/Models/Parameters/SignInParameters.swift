//
//  SignInParameters.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

struct SignInParameters {

    let usernameId: String
    let passwordId: String

    let username: String
    let password: String

    let captcha: String?

    var dictionary: [String: String] {
        guard usernameId != passwordId else { return [:] }
        var dictionary = [usernameId: username, passwordId: password]
        if let captcha = captcha {
            dictionary["captcha"] = captcha
        }
        return dictionary
    }

}

