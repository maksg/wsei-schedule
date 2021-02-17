//
//  UserDefaults+ObjectSaving.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 17/02/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setObject<Object>(_ object: Object, forKey: String) where Object: Encodable {
        guard let data = try? JSONEncoder().encode(object) else { return }
        set(data, forKey: forKey)
    }

    func getObject<Object>(forKey: String) -> Object? where Object: Decodable {
        guard let data = self.data(forKey: forKey) else { return nil }
        return try? JSONDecoder().decode(Object.self, from: data)
    }
}
