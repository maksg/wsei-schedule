//
//  ScheduleViewController.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit
import WebKit

class ScheduleViewController: UIViewController, View {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var webView: WKWebView!
    
    typealias ViewModelType = ScheduleViewModel
    var viewModel: ScheduleViewModel! {
        didSet {
            self.title = viewModel.title
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadSchedule(with: viewModel.scheduleURL)
    }
    
    // MARK: Methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedSectionHeaderHeight = 40.0
        tableView.sectionHeaderHeight = 40.0
        
        let cellNib = UINib(nibName: "ScheduleCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ScheduleCell")
        
        let headerNib = UINib(nibName: "ScheduleHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ScheduleHeader")
    }
    
    private func configureWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
    }
    
    private func reloadSchedule(with url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.scheduleCellViewModels.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scheduleCellViewModels[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = Array(viewModel.scheduleCellViewModels.keys.sorted())[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScheduleHeader") as? ScheduleHeader
        header?.viewModel = ScheduleHeaderViewModel(date: date)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        let cellViewModels = viewModel.scheduleCellViewModels[indexPath.section]
        let cellViewModel = cellViewModels?[indexPath.row]
        if indexPath.section == 0 && indexPath.row == 0 {
            cellViewModel?.toggleDetails()
        }
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModels = viewModel.scheduleCellViewModels[indexPath.section]
        viewModels?[indexPath.row].toggleDetails()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ScheduleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        reloadSchedule(with: viewModel.scheduleURL)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        reloadSchedule(with: viewModel.scheduleURL)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url == viewModel.scheduleURL {
            selectSchedule(forAlbumNumber: "10951")
        }
    }
    
    private func selectSchedule(forAlbumNumber albumNumber: String) {
        run(.selectType) { [weak self] _ in
            self?.run(.selectSearch, completionHandler: { [weak self] _ in
                self?.run(.selectAlbumNumber(number: "10951"), completionHandler: { [weak self] _ in
                    self?.run(.getScheduleContent, completionHandler: { [weak self] data in
                        self?.viewModel.convertDataToLectureList(data: data)
                        self?.tableView.reloadData()
                    })
                })
            })
        }
    }
    
    private func run(_ script: WSEIScript, completionHandler: @escaping (Any?) -> Void) {
        webView.evaluateJavaScript(script.content) { [weak self] (data, error) in
            if let _ = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.run(script, completionHandler: completionHandler)
                })
            } else {
                completionHandler(data)
            }
        }
    }
    
}
