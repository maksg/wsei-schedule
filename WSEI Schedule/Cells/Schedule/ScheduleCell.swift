//
//  ScheduleCell.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell, CellView {
    
    // MARK: IBOutlets

    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var classroomLabel: UILabel!
    @IBOutlet private weak var lecturerLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var detailsStackView: UIStackView!
    
    // MARK: Properties
    
    typealias ViewModelType = ScheduleCellViewModel
    var viewModel: ScheduleCellViewModel! {
        didSet {
            setupCell()
        }
    }
    
    // MARK: Methods
    
    private func setupCell() {
        subjectLabel.text = viewModel.subject
        timeLabel.text = viewModel.time
        classroomLabel.text = viewModel.classroom
        lecturerLabel.text = viewModel.lecturer
        codeLabel.text = viewModel.code
        
        detailsStackView.isHidden = viewModel.hideDetails
    }
    
}
