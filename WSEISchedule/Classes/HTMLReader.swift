//
//  HTMLReader.swift
//  HTMLReader
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import SwiftSoup

final class HTMLReader {

    func readSignInData(fromHtml html: String) throws -> SignInData {
        let doc = try SwiftSoup.parse(html)
        let form = try doc.select("#form_logowanie").first()
        let elements = try form?.select("tr[style=''] input") ?? Elements()

        var usernameId: String = ""
        var passwordId: String = ""
        for element in elements {
            let id = try element.attr("id")
            if try element.attr("type") == "password" {
                passwordId = id
            } else {
                usernameId = id
            }
        }

        let captchaImg = try form?.select("#captchaImg").first()
        let captchaSrc = try captchaImg?.attr("src")

        return SignInData(usernameId: usernameId, passwordId: passwordId, captchaSrc: captchaSrc)
    }

}
