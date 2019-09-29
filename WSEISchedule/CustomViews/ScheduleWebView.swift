//
//  ScheduleWebView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import WebKit
import SwiftUI

final class ScheduleWebView: NSObject, UIViewRepresentable {
    
    private var scheduleURL: URL {
        URL(string: "https://estudent.wsei.edu.pl/SG/PublicDesktop.aspx?fileShareToken=95-88-6B-EB-B0-75-96-FB-A9-7C-AE-D7-5C-DB-90-49")!
    }
    
    private var webView: WKWebView!
    
    var albumNumber: String = ""
    var addLectures: ((Any?) -> Void)?
    var finishLoadingLectures: (() -> Void)?
    
    override init() {
        super.init()
        
        let config = WKWebViewConfiguration()
        let script = WKUserScript(source: WSEIScript.observeContentChange.content,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")
        
        let frame = CGRect(x: 0, y: 0, width: 800, height: 400)
        webView = WKWebView(frame: frame, configuration: config)
        webView.navigationDelegate = self
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        albumNumber = "10951"
        reload()
    }
    
    func reload() {
        guard !albumNumber.isEmpty else { return }
//        refreshControl?.beginRefreshing()
        let request = URLRequest(url: scheduleURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }
    
    func run(_ script: WSEIScript, completionHandler: ((Any?) -> Void)? = nil) {
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
    
    private func getScheduleContent() {
        run(.getScheduleContent, completionHandler: { [weak self] data in
            self?.addLectures?(data)
            self?.run(.goToNextPage, completionHandler: { [weak self] data in
                let isLastPage = (data as? Bool) ?? false
                if isLastPage {
                    self?.finishLoadingLectures?()
//                    self?.tableView.reloadData()
//                    self?.refreshControl?.endRefreshing()
                }
            })
        })
    }
    
    private func selectSchedule(forAlbumNumber albumNumber: String) {
//        run(.showHistory)
        
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
    
}

extension ScheduleWebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        webView.reload()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        webView.reload()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url == scheduleURL {
            selectSchedule(forAlbumNumber: albumNumber)
        }
    }
}

extension ScheduleWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        getScheduleContent()
    }
    
}


#if DEBUG
struct WSEIWebView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleWebView()
            .previewDevice(.init(stringLiteral: "iPad Pro (9.7-inch)"))
    }
}
#endif
