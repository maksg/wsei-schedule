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
    static var settings: Image { Image(systemName: "gear") }

    static var time: Image { Image(systemName: "clock") }
    static var classroom: Image { Image(systemName: "location") }
    static var code: Image { Image(systemName: "number.circle.fill") }
    static var lecturer: Image { Image(systemName: "person.crop.circle.fill") }
    static var comments: Image { Image(systemName: "info.circle.fill") }

    static var singOut: Image { Image(systemName: "power") }
    
}
