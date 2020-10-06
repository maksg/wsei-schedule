//
//  Publishers+Keyboard.swift
//  Happ
//
//  Created by Maksymilian Galas on 13/09/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import Combine
import UIKit

extension Publishers {

    static var keyboardInfo: AnyPublisher<KeyboardInfo, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { KeyboardInfo(height: $0.keyboardHeight, animation: $0.keyboardAnimation) }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { KeyboardInfo(height: 0, animation: $0.keyboardAnimation) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }

}

