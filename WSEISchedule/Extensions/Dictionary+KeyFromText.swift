//
//  Dictionary+KeyFromText.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 04/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {

    mutating func addKey(fromText text: String) {
        let splitRow = text.split(separator: ":", maxSplits: 1)
        guard splitRow.count >= 2 else { return }

        let key = String(splitRow[0])
        let value = splitRow[1].trimmingCharacters(in: .whitespaces)
        self[key] = value
    }

}
