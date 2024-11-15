//
//  HTMLReader.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLReaderError: Error {
    case invalidHtml
}

extension HTMLReaderError: LocalizedError {
    public var errorDescription: String? {
        return Translation.Error.unknown.localized
    }
}

final class HTMLReader {

    func isSignedIn(fromHtml html: String) -> Bool {
        let doc = try? SwiftSoup.parse(html)
        let sidebar = try? doc?.select("#sidebar").first()
        return sidebar != nil
    }

    func readStudentInfo(fromHtml html: String) throws -> Student {
        let doc = try SwiftSoup.parse(html)
        guard
            let photoSource = try doc.select("#zdjecie_glowne").first()?.attr("src"),
            let infoElement = try doc.select(".identify").first()
        else { throw HTMLReaderError.invalidHtml }

        let photoUrl = URL(string: "https://dziekanat.wsei.edu.pl\(photoSource)")!

        try infoElement.select("p").append("\\n")
        let info = try infoElement.text().replacingOccurrences(of: "\\n", with: "\n")
        let infoLines = info.split(separator: "\n").map({ $0.trimmingCharacters(in: .whitespaces) })

        if infoLines.count >= 4 {
            return Student(name: infoLines[1], albumNumber: infoLines[2], courseName: infoLines[3], photoUrl: photoUrl)
        } else {
            return Student(name: "", albumNumber: "", courseName: "", photoUrl: photoUrl)
        }
    }

    func readLectures(fromHtml html: String) throws -> [[String: String]] {
        let doc = try SwiftSoup.parse(html)
        guard
            let tableBody = try doc.select("#gridViewPlanyStudentow_DXMainTable tbody").first(),
            try doc.select("#gridViewPlanyStudentow_DXEmptyRow").first() == nil
        else { throw HTMLReaderError.invalidHtml }

        var headers: [String] = []

        var currentDateRowText = ""
        let rows = try tableBody.select("> tr")
        let lectures = try rows.compactMap { row -> [String: String]? in
            let id = row.id()
            let texts = try row.select("> td").map({ try $0.text() })

            if id == "gridViewPlanyStudentow_DXHeadersRow0" {
                headers = texts
                return nil
            } else if id.contains("gridViewPlanyStudentow_DXGroupRowExp") {
                currentDateRowText = texts.first(where: { !$0.isEmpty }) ?? ""
                return nil
            } else if id.contains("gridViewPlanyStudentow_DXDataRow") {
                var dictionary = zipTableData(headers: headers, texts: texts)
                dictionary.addKey(fromText: currentDateRowText)
                return dictionary
            } else {
                return nil
            }
        }

        return lectures
    }

    private func zipTableData(headers: [String], texts: [String]) -> [String: String] {
        zip(headers, texts).reduce([String: String]()) { result, group in
            let (header, text) = group
            var result = result
            if !header.isEmpty {
                result[header] = text
            }
            return result
        }
    }

    func readGrades(fromHtml html: String) throws -> [Grade] {
        let doc = try SwiftSoup.parse(html)

        guard
            let table = try doc.select("table").first()
        else { throw HTMLReaderError.invalidHtml }

        let headers = try table.select("thead th").map({ try $0.text() })
        let rows = try table.select("tbody tr")

        return try rows.map({ row in
            let elements = try row.select("td")
            try elements.select("br").append("\\n")
            let texts = try elements.map({ try $0.text() })
            let dictionary = zipTableData(headers: headers, texts: texts)
            return Grade(fromDictionary: dictionary)
        }).filter({ !$0.value.isEmpty || !$0.ects.isEmpty })
    }

    func readGradeSemesters(fromHtml html: String) throws -> [GradeSemester] {
        let doc = try SwiftSoup.parse(html)
        let cards = try doc.select("#accordion .card")

        guard !cards.isEmpty() else { throw HTMLReaderError.invalidHtml }

        var gradeSemesters = try cards.map { card in
            let id = try card.select("div[id*='Przedmioty']").first()?.id().digits ?? ""
            let header = try card.select("#headingOne .row div").first()
            try header?.select("br").append("\\n")
            let text = try header?.text().replacingOccurrences(of: "\\n", with: "\n") ?? ""
            return GradeSemester(id: id, text: text)
        }

        guard !gradeSemesters.isEmpty else { throw HTMLReaderError.invalidHtml }
        let currentSemesterCardHtml = try cards.first()?.select("div[id*='Przedmioty']").first()?.html() ?? ""
        let currentSemesterGrades = try readGrades(fromHtml: currentSemesterCardHtml)
        gradeSemesters[0].grades = currentSemesterGrades

        return gradeSemesters
    }

}

private extension String {
    var digits: String {
        components(separatedBy: .decimalDigits.inverted).joined()
    }
}
