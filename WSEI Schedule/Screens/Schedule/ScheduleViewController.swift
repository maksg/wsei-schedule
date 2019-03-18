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
    
    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: Properties
    
    typealias ViewModelType = ScheduleViewModel
    var viewModel: ScheduleViewModel! {
        didSet {
            self.title = viewModel.title
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureWebView(with: viewModel.scheduleURL)
    }
    
    // MARK: Methods
    
    private func configureWebView(with url: URL) {
        webView.navigationDelegate = self
        
        let websiteDataTypes = Set<String>(arrayLiteral: WKWebsiteDataTypeCookies)
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler:{ })
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

}

extension ScheduleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url as Any)
        
        if webView.url == viewModel.scheduleURL {
            print("222")
            selectSchedule(forAlbumNumber: "10951")
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("terminate")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("redirect")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    private func selectSchedule(forAlbumNumber albumNumber: String) {
        run(.selectType) { [weak self] in
            self?.run(.selectSearch, completionHandler: { [weak self] in
                self?.run(.selectAlbumNumber(number: "10951"), completionHandler: { [weak self] in
                    self?.run(.getScheduleContent, completionHandler: {
                    })
                })
            })
        }
    }
    
    private func run(_ script: WSEIScript, completionHandler: @escaping () -> Void) {
        webView.evaluateJavaScript(script.content) { [weak self] (data, error) in
            if let error = error {
                print("\(script) error = \(error)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.run(script, completionHandler: completionHandler)
                })
            }
            else {
                print("\(script) data = \(data as Any)")
                completionHandler()
            }
        }
    }
    
}
