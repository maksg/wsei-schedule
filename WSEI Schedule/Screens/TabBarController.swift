//
//  TabBarController.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, View {
    
    // MARK: Properties
    
    typealias ViewModelType = TabBarViewModel
    var viewModel: TabBarViewModel! {
        didSet {
            configureViewControllers()
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.accessibilityIgnoresInvertColors = true
        NotificationCenter.default.addObserver(forName: UIAccessibility.invertColorsStatusDidChangeNotification,object: nil, queue: nil) { [weak self] notification in
            self?.updateTabBarColor()
        }
        updateTabBarColor()
    }
    
    func updateTabBarColor() {
        if UIAccessibility.isInvertColorsEnabled {
            tabBar.isTranslucent = false
            tabBar.barTintColor = .black
        } else {
            tabBar.isTranslucent = true
            tabBar.barTintColor = .white
        }
    }
    
    // MARK: Methods
    
    private func configureViewControllers() {
        guard let viewControllers = self.viewControllers else { return }
        for (viewController, viewModel) in zip(viewControllers, viewModel.viewModels) {
            guard let navigationController = viewController as? UINavigationController else { continue }
            
            switch navigationController.topViewController {
            case let scheduleVC as ScheduleViewController:
                scheduleVC.viewModel = viewModel as? ScheduleViewModel
            case let settingsVC as SettingsViewController:
                settingsVC.viewModel = viewModel as? SettingsViewModel
            default:
                break
            }
        }
    }
    
}
