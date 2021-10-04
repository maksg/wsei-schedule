//
//  HTMLReader.swift
//  HTMLReader
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLReaderError: Error {
    case invalidHtml
    case invalidCaptcha
}

extension HTMLReaderError: LocalizedError {
    public var errorDescription: String? {
        return Translation.Error.unknown.localized
    }
}

final class HTMLReader {

    func readSignInData(fromHtml html: String) throws -> SignInData {
        let doc = try SwiftSoup.parse(html)
        guard let form = try doc.select("#form_logowanie").first() else { throw HTMLReaderError.invalidHtml }

        let elements = try form.select("tr[style=''] input")

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

        let captchaSrc = try form.select("#captchaImg").first()?.attr("src")
        return SignInData(usernameId: usernameId, passwordId: passwordId, captchaSrc: captchaSrc)
    }

    func readStudentInfo(fromHtml html: String) throws -> StudentInfo {
        let doc = try SwiftSoup.parse(html)
        guard
            let photoSource = try doc.select("#zdjecie_glowne").first()?.attr("src"),
            let paragraphElement = try doc.select("#td_naglowek p").first()
        else { throw HTMLReaderError.invalidHtml }

        let photoUrl = URL(string: "https://dziekanat.wsei.edu.pl\(photoSource)")!

        try paragraphElement.select("br").append("\\n")
        let paragraph = try paragraphElement.text().replacingOccurrences(of: "\\n", with: "\n")
        let paragraphLines = paragraph.split(separator: "\n").map({ $0.trimmingCharacters(in: .whitespaces) })

        if paragraphLines.count >= 4 {
            return StudentInfo(name: paragraphLines[1], albumNumber: paragraphLines[2], courseName: paragraphLines[3], photoUrl: photoUrl)
        } else {
            return StudentInfo(name: "", albumNumber: "", courseName: "", photoUrl: photoUrl)
        }

    }

    func readLectures(fromHtml html: String) throws -> [[String: String]] {
        let doc = try SwiftSoup.parse(html)
        print(html)
        guard
            let tableBody = try doc.select("#gridViewPlanyStudentow_DXMainTable tbody").first(),
            try doc.select("#gridViewPlanyStudentow_DXEmptyRow").first() == nil
        else { throw HTMLReaderError.invalidHtml }

        let headers = try tableBody.select("#gridViewPlanyStudentow_DXHeadersRow0 td.dxgvHeader_Aqua").map({ try $0.text() })

        var currentDateRowText = ""
        let rows = try tableBody.select("tr.dxgvGroupRow_Aqua, tr.dxgvDataRow_Aqua")
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

    func readSignInError(fromHtml html: String) throws -> String {
        let doc = try SwiftSoup.parse(html)
        guard
            let errorElement = try doc.select(".validation-summary-errors ul li").first()
        else { throw HTMLReaderError.invalidHtml }

        let errorMessage = try errorElement.text()
        if errorMessage.contains("captcha") || errorMessage.contains("kod z obrazka") {
            throw HTMLReaderError.invalidCaptcha
        } else {
            return errorMessage
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
