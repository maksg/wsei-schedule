//
//  Dictionary+Index.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

extension Dictionary where Key: Comparable {
    
    subscript(index: Int) -> Value? {
        get {
            let keys = Array(self.keys.sorted())
            guard keys.count > 0 else { return nil }
            let key = keys[index]
            return self[key]
        }
        set {
            let keys = Array(self.keys.sorted())
            guard keys.count > 0 else { return }
            let key = keys[index]
            self[key] = newValue
        }
    }
    
}
