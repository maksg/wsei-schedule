//
//  UIHostingController+TabBarItemable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

extension UIHostingController {
    
    convenience init(tabBarView: Content) {
        self.init(rootView: tabBarView)
        tabBarItem = (tabBarView as? TabBarItemable)?.tabBarItem
    }
    
}
