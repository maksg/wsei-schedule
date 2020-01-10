//
//  UIImage+Named.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    
    static var logo: UIImage { UIImage(named: "logo")! }
    static var placeholder: UIImage { UIImage(named: "placeholder")! }
    static var schedule: UIImage { UIImage(systemName: "clock.fill")! }
    static var settings: UIImage { UIImage(systemName: "gear")! }
    
}

