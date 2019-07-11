//
//  KeyboardObservable.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 20/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
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
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                       object: nil, queue: nil, using: keyboardWillShow)
        notificationCenter.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                       object: nil, queue: nil, using: keyboardDidShow)
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: nil, using: keyboardWillHide)
        notificationCenter.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                       object: nil, queue: nil, using: keyboardDidHide)
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: nil, using: keyboardWillChangeFrame)
        notificationCenter.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification,
                                       object: nil, queue: nil, using: keyboardDidChangeFrame)
	}

	func unregisterFromKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
	}

}
