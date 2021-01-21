//
//  String+UIImage.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 21/01/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit

extension String {

    func image() -> UIImage? {
        let size = CGSize(width: 30, height: 20)
        let rect = CGRect(origin: CGPoint(), size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            (self as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        }
    }

}
