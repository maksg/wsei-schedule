//
//  String+FormUrlEncoded.swift
//  String+FormUrlEncoded
//
//  Created by Maksymilian Galas on 26/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation

extension String {

    var formUrlEncoded: String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._* ")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+") ?? ""
    }

}
