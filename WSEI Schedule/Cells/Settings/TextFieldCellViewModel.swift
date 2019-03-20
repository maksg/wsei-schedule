//
//  TextFieldCellViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

protocol TextFieldCellViewModelDelegate: class {
    func textFieldDidEndEditing(withText text: String)
}

class TextFieldCellViewModel: CellViewModel {
    
    // MARK: Properties
    
    private(set) var title: String
    private(set) var placeholder: String
    private(set) var text: String
    
    weak var delegate: TextFieldCellViewModelDelegate?
    
    // MARK: Initialization
    
    init(title: String, placeholder: String, text: String) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }
    
    // MARK: Methods
    
    func didEndEditing(_ text: String) {
        self.text = text
        delegate?.textFieldDidEndEditing(withText: text)
    }
    
}
