//
//  KeyboardObservable.swift
//
//  Created by Maksymilian Galas on 13/09/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import UIKit

protocol KeyboardObservable {

    func keyboardWillShow(_ notification: Notification)
    func keyboardDidShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func keyboardDidHide(_ notification: Notification)
    func keyboardWillChangeFrame(_ notification: Notification)
    func keyboardDidChangeFrame(_ notification: Notification)

    func registerForKeyboardEvents()
    func unregisterFromKeyboardEvents()

}

extension KeyboardObservable {

    func keyboardWillShow(_ notification: Notification) {}
    func keyboardDidShow(_ notification: Notification) {}
    func keyboardWillHide(_ notification: Notification) {}
    func keyboardDidHide(_ notification: Notification) {}
    func keyboardWillChangeFrame(_ notification: Notification) {}
    func keyboardDidChangeFrame(_ notification: Notification) {}

    func registerForKeyboardEvents() {
        addObserver(forName: UIResponder.keyboardWillShowNotification, using: keyboardWillShow)
        addObserver(forName: UIResponder.keyboardDidShowNotification, using: keyboardDidShow)
        addObserver(forName: UIResponder.keyboardWillHideNotification, using: keyboardWillHide)
        addObserver(forName: UIResponder.keyboardDidHideNotification, using: keyboardDidHide)
        addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, using: keyboardWillChangeFrame)
        addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, using: keyboardDidChangeFrame)
    }

    private func addObserver(forName name: NSNotification.Name?, using block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: block)
    }

    func unregisterFromKeyboardEvents() {
        removeObserver(forName: UIResponder.keyboardWillShowNotification)
        removeObserver(forName: UIResponder.keyboardDidShowNotification)
        removeObserver(forName: UIResponder.keyboardWillHideNotification)
        removeObserver(forName: UIResponder.keyboardDidHideNotification)
        removeObserver(forName: UIResponder.keyboardWillChangeFrameNotification)
        removeObserver(forName: UIResponder.keyboardDidChangeFrameNotification)
    }

    private func removeObserver(forName name: NSNotification.Name?) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

}
