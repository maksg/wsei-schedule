//
//  Dictionary+Sequence.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 04/12/2024.
//  Copyright © 2024 Infinity Pi Ltd. All rights reserved.
//

public extension Dictionary where Key == String, Value == String {
    subscript(keys: Key...) -> Value? {
        for key in keys {
            guard let value = self[key] else { continue }
            return value
        }
        return nil
    }
}
