//
//  ScheduleViewController.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import UIKit
import WebKit

class ScheduleViewController: UITableViewController, View {
    
    // MARK: Properties
    
    private var webView: WKWebView!
    
    typealias ViewModelType = ScheduleViewModel
    var viewModel: ScheduleViewModel! {
        didSet {
            title = viewModel.title
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
        
        reloadSchedule()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        refreshControl?.endRefreshing()
    }
    
    // MARK: Methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl?.addTarget(self, action: #selector(reloadSchedule), for: .valueChanged)
        refreshControl?.tintColor = UIColor.white
        
        // Refresh control tint color hack
        tableView.contentOffset = CGPoint(x: 0.0, y: -refreshControl!.frame.size.height)
        tableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedSectionHeaderHeight = 34.0
        tableView.sectionHeaderHeight = 34.0
        
        let cellNib = UINib(nibName: "ScheduleCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ScheduleCell")
        
        let headerNib = UINib(nibName: "ScheduleHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ScheduleHeader")
    }
    
    private func configureWebView() {let config = WKWebViewConfiguration()
        let script = WKUserScript(source: WSEIScript.observeContentChange.content,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")
        
        let frame = CGRect(x: 0, y: 0, width: 800, height: 400)
        webView = WKWebView(frame: frame, configuration: config)
        webView.navigationDelegate = self
    }
    
    @objc private func reloadSchedule() {
        guard !viewModel.albumNumber.isEmpty else { return }
        refreshControl?.beginRefreshing()
        let url = viewModel.scheduleURL
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

}

extension ScheduleViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.scheduleCellViewModels.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scheduleCellViewModels[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = Array(viewModel.scheduleCellViewModels.keys.sorted())[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScheduleHeader") as? ScheduleHeader
        header?.viewModel = ScheduleHeaderViewModel(date: date)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        let cellViewModels = viewModel.scheduleCellViewModels[indexPath.section]
        let cellViewModel = cellViewModels?[indexPath.row]
        if indexPath.section == 0 && indexPath.row == 0 {
            cellViewModel?.hideDetails = false
        }
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModels = viewModel.scheduleCellViewModels[indexPath.section]
        viewModels?[indexPath.row].hideDetails.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ScheduleViewController: WKNavigationDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        reloadSchedule()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        reloadSchedule()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url == viewModel.scheduleURL {
            let albumNumber = viewModel.albumNumber
            selectSchedule(forAlbumNumber: albumNumber)
        }
    }
    
    private func selectSchedule(forAlbumNumber albumNumber: String) {
        var isSame = true
        run(.selectType) { [weak self] data in
            isSame = isSame && (data as? Bool) ?? false
            
            self?.run(.selectAlbumNumber(number: albumNumber), completionHandler: { [weak self] data in
                isSame = isSame && (data as? Bool) ?? false
                
                if isSame {
                    self?.getScheduleContent()
                }
            })
        }
    }
    
    private func run(_ script: WSEIScript, completionHandler: ((Any?) -> Void)? = nil) {
        webView.evaluateJavaScript(script.content) { [weak self] (data, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.run(script, completionHandler: completionHandler)
                })
            } else {
                completionHandler?(data)
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        getScheduleContent()
    }
    
    private func getScheduleContent() {
        run(.getScheduleContent, completionHandler: { [weak self] data in
            self?.viewModel.addLectures(fromData: data)
            self?.run(.goToNextPage, completionHandler: { [weak self] data in
                let isLastPage = (data as? Bool) ?? false
                if isLastPage {
                    self?.viewModel.finishLoadingLectures()
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            })
        })
    }
    
}
