//
//  UIImage+Named.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    static var placeholder: UIImage { UIImage(named: "placeholder")! }

    static var back: UIImage { UIImage(systemName: "chevron.backward")! }
    static var forward: UIImage { UIImage(systemName: "chevron.forward")! }
    static var share: UIImage { UIImage(systemName: "square.and.arrow.up")! }
    static var secure: UIImage { UIImage(systemName: "lock.fill")! }
}

