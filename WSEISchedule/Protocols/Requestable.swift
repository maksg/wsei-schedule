//
//  Requestable.swift
//  Requestable
//
//  Created by Maksymilian Galas on 19/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol Requestable {

    func onDataSuccess(_ callback: @escaping (String) -> Void) -> Self
    func onImageDownloadSuccess(_ callback: @escaping (UIImage?) -> Void) -> Self
    func onError(_ callback: @escaping (Error) -> Void) -> Self

    func make()

}

