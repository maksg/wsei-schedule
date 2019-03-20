//
//  TextFieldCell.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell, CellView {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: Properties
    
    typealias ViewModelType = TextFieldCellViewModel
    var viewModel: TextFieldCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            textField.placeholder = viewModel.placeholder
            textField.text = viewModel.text
        }
    }
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) { }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        viewModel.didEndEditing(text)
    }
    
}
