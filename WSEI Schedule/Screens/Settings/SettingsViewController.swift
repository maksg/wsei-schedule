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
        hideKeyboardOnTap()
        
        navigationController?.navigationBar.accessibilityIgnoresInvertColors = true
        NotificationCenter.default.addObserver(forName: UIAccessibility.invertColorsStatusDidChangeNotification,object: nil, queue: nil) { [weak self] notification in
            self?.updateNavigationBarColor()
        }
        updateNavigationBarColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Methods
    
    private func updateNavigationBarColor() {
        if UIAccessibility.isInvertColorsEnabled {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = .black
        } else {
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldCellNib, forCellReuseIdentifier: "TextFieldCell")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func saveAlbumNumber(_ albumNumber: String) {
        UserDefaults.standard.set(albumNumber, forKey: "AlbumNumber")
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
        saveAlbumNumber(text)
    }
    
}
