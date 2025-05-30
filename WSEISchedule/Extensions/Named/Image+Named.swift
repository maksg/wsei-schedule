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

    static var refresh: Image { Image(systemName: "arrow.clockwise") }

    static var schedule: Image { Image(systemName: "calendar") }
    static var scheduleHistory: Image { Image(systemName: "clock.arrow.circlepath") }
    static var grades: Image { Image(systemName: "rosette") }
    static var settings: Image { Image(systemName: "gearshape.2.fill") }

    static var comingSoon: Image { Image(systemName: "megaphone.fill") }

    static var time: Image { Image(systemName: "alarm.fill") }
    static var classroom: Image { Image(systemName: "location.fill") }
    static var code: Image { Image(systemName: "number") }
    static var lecturer: Image { Image(systemName: "person.fill") }
    static var comments: Image { Image(systemName: "info.circle.fill") }

    static var signOut: Image { Image(systemName: "power") }
}
