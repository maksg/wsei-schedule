//
//  SettingsViewController.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, View {
    
    // MARK: Properties
    
    typealias ViewModelType = SettingsViewModel
    var viewModel: SettingsViewModel! {
        didSet {
            self.title = viewModel.title
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
