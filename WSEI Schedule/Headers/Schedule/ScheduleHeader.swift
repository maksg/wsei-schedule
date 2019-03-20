//
//  ScheduleHeader.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class ScheduleHeader: UITableViewHeaderFooterView, View {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: Properties
    
    typealias ViewModelType = ScheduleHeaderViewModel
    var viewModel: ScheduleHeaderViewModel! {
        didSet {
            dateLabel.text = viewModel.dateText
        }
    }

}
