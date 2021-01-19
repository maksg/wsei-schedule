//
//  Image+Named.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension Image {
    
    static var logo: Image { Image("logo") }

    static var schedule: Image { Image(systemName: "calendar") }
    static var settings: Image {
        if #available(iOS 14, macOS 11, *) {
            return Image(systemName: "gearshape.2.fill")
        } else {
            return Image(systemName: "gear")
        }
    }

    static var time: Image { Image(systemName: "alarm.fill") }
    static var classroom: Image { Image(systemName: "location.fill") }
    static var code: Image { Image(systemName: "number") }
    static var lecturer: Image { Image(systemName: "person.fill") }
    static var comments: Image { Image(systemName: "info.circle.fill") }

    static var signOut: Image { Image(systemName: "power") }
    
}
