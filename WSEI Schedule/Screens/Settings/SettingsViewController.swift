//
//  SettingsViewController.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, View {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    typealias ViewModelType = SettingsViewModel
    var viewModel: SettingsViewModel! {
        didSet {
            title = viewModel.title
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerForKeyboardEvents()
        hideKeyboardOnTap()
    }
    
    // MARK: Methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 44.0
        
        let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldCellNib, forCellReuseIdentifier: "TextFieldCell")
    }
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        let title = Translation.Settings.albumNumber.localized
        let placeholder = "00000"
        let albumNumber = UserDefaults.standard.string(forKey: "AlbumNumber") ?? ""
        cell.viewModel = TextFieldCellViewModel(title: title, placeholder: placeholder, text: albumNumber)
        cell.viewModel.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SettingsViewController: TextFieldCellViewModelDelegate {
    
    func textFieldDidEndEditing(withText text: String) {
        UserDefaults.standard.set(text, forKey: "AlbumNumber")
    }
    
}

extension SettingsViewController: KeyboardObserver {
    
    func keyboardWillShow(_ notification: Notification) {
        bottomConstraint.constant = notification.keyboardSize.height - view.safeAreaInsets.bottom
        animateKeyboard(for: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0.0
        animateKeyboard(for: notification)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        bottomConstraint.constant = notification.keyboardSize.height - view.safeAreaInsets.bottom
        animateKeyboard(for: notification)
    }
    
    private func animateKeyboard(for notification: Notification) {
        let duration = notification.keyboardAnimationDuration
        let delay = TimeInterval(0.0)
        let options = notification.keyboardAnimationCurve
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            
        })
    }
    
}
