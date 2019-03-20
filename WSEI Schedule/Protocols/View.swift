//
//  View.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

protocol View {
    
    associatedtype ViewModelType: ViewModel
    
    var viewModel: ViewModelType! {
        get
        set
    }
    
}
