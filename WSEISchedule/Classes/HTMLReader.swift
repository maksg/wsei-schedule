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

    func readLectures(fromHtml html: String) throws -> [[String: String]] {
        let doc = try SwiftSoup.parse(html)
        let tableBody = try doc.select("#gridViewPlanyStudentow_DXMainTable tbody").first()
        let headers = try tableBody?.select("#gridViewPlanyStudentow_DXHeadersRow0 td.dxgvHeader_Aqua").map({ try $0.text() }) ?? []

        var currentDateRowText = ""
        let rows = try tableBody?.select("tr.dxgvGroupRow_Aqua, tr.dxgvDataRow_Aqua") ?? Elements()
        let lectures = try rows.compactMap { row -> [String: String]? in
            let elements = try row.select("td")

            if row.hasClass("dxgvGroupRow_Aqua") {
                currentDateRowText = try elements.map({ try $0.text() }).first(where: { !$0.isEmpty }) ?? ""
                return nil
            } else {
                var dictionary = try generateLectureDictionary(headers: headers, elements: elements)
                dictionary.addDateKey(currentDateRowText)
                return dictionary
            }
        }

        return lectures
    }

    private func generateLectureDictionary(headers: [String], elements: Elements) throws -> [String: String] {
        try zip(headers, elements).reduce([String: String]()) { result, group in
            let (header, element) = group
            var result = result
            if !header.isEmpty {
                let text = try element.text()
                result[header] = text
            }
            return result
        }
    }

}

private extension Dictionary where Key == String, Value == String {

    mutating func addDateKey(_ dateRowText: String) {
        let splitDateRow = dateRowText.split(separator: ":", maxSplits: 1)
        guard splitDateRow.count >= 2 else { return }

        let key = String(splitDateRow[0])
        let value = splitDateRow[1].trimmingCharacters(in: .whitespaces)
        self[key] = value
    }

}
