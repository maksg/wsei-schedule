//
//  UIViewController+IsModal.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 05/06/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import UIKit

extension UIViewController {

    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

}
