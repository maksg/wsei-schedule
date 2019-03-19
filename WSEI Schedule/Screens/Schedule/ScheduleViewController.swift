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
        configureWebView(with: viewModel.scheduleURL)
    }
    
    // MARK: Methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "ScheduleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ScheduleCell")
    }
    
    private func configureWebView(with url: URL) {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        let websiteDataTypes = Set<String>(arrayLiteral: WKWebsiteDataTypeCookies)
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler:{ })
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lectures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        cell.viewModel = viewModel.scheduleCellViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.scheduleCellViewModels[indexPath.row].toggleDetails()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ScheduleViewController: WKNavigationDelegate {
    
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
