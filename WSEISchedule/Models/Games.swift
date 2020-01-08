//
//  Games.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 08/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import Foundation

enum Games: CaseIterable, Identifiable {
    var id: String { name }
    
    case scareCrows
    case scareCrowsAR
    case theFit
    case attempt
    
    var name: String {
        switch self {
        case .scareCrows:
            return "Scare Crows"
        case .scareCrowsAR:
            return "Scare Crows AR"
        case .theFit:
            return "The Fit"
        case .attempt:
            return "Attempt"
        }
    }
    
    var link: String {
        switch self {
        case .scareCrows:
            return "https://apps.apple.com/us/app/scare-crows/id912853480"
        case .scareCrowsAR:
            return "https://apps.apple.com/us/app/scare-crows-ar/id1293309472"
        case .theFit:
            return "https://apps.apple.com/us/app/the-fit/id1039646496"
        case .attempt:
            return "https://apps.apple.com/us/app/attempt/id1244285261"
        }
    }
    
    var url: URL { URL(string: link)! }
}
