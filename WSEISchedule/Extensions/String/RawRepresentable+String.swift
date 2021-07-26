//
//  RawRepresentable+String.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == String {
    
    var localized: String {
        return rawValue.localized
    }
    
}
