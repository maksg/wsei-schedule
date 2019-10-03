//
//  ScheduleWebView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import WebKit
import SwiftUI
import Vision

final class ScheduleWebView: NSObject, UIViewRepresentable {
    
    private var mainURL: URL {
        URL(string: "https://dziekanat.wsei.edu.pl/")!
    }
    
    private var signInURL: URL {
        URL(string: "https://dziekanat.wsei.edu.pl/Konto/LogowanieStudenta")!
    }
    
    private var scheduleURL: URL {
        URL(string: "https://dziekanat.wsei.edu.pl/Plany/PlanyStudentow")!
    }
    
    private var webView: WKWebView!
    
    var albumNumber: String = ""
    var loadLectures: ((Any?) -> Void)?
    
    var textRecognitionRequest: VNRecognizeTextRequest
    let textRecognitionWorkQueue: DispatchQueue
    
    override init() {
        textRecognitionRequest = VNRecognizeTextRequest()
        
        textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        
        super.init()
        
        let config = WKWebViewConfiguration()
        let script = WKUserScript(source: WSEIScript.observeContentChange.content,
                                  injectionTime: .atDocumentEnd,
                                  forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")
        
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        webView = WKWebView(frame: frame, configuration: config)
        webView.navigationDelegate = self
        
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map { String($0) }
        textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            guard !observations.isEmpty else {
                self?.captureSnapshot()
                return
            }
            
            let candidates = observations.compactMap { $0.topCandidates(1).first?.string }
            
            DispatchQueue.main.async { [weak self] in
                if let captcha = candidates.last?.replacingOccurrences(of: " ", with: ""), candidates.count > 1 {
                    if captcha.count == 5 {
                        self?.run(.setLogin("maksymiliangalas"))
                        self?.run(.setPassword("Ford1997"))
                        self?.run(.setCaptcha(captcha))
                        self?.run(.login)
                    } else {
                        self?.reload()
                    }
                } else {
                    self?.run(.setLogin("maksymiliangalas"))
                    self?.run(.setPassword("Ford1997"))
                    self?.run(.login)
                }
            }
        }
        textRecognitionRequest.minimumTextHeight = 0.03
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.customWords = characters
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        albumNumber = "10951"
        reload()
    }
    
    func reload() {
//        refreshControl?.beginRefreshing()
        let request = URLRequest(url: signInURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }
    
    func showSchedule() {
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
            self?.loadLectures?(data)
//            self?.tableView.reloadData()
//            self?.refreshControl?.endRefreshing()
        })
    }
    
    private func recognizeTextInImage(_ image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }

        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    private func captureSnapshot() {
        DispatchQueue.main.async { [weak self] in
            self?.webView.takeSnapshot(with: nil) { [weak self] (image, error) in
                self?.recognizeTextInImage(image)
            }
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
        if webView.url == signInURL {
            captureSnapshot()
        }
        if webView.url == mainURL {
            showSchedule()
        }
        if webView.url == scheduleURL {
            run(.refreshSchedule)
        }
    }
}

extension ScheduleWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        getScheduleContent()
    }
    
}


struct WSEIWebView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleWebView()
            .previewDevice(.init(stringLiteral: "iPad Pro (9.7-inch)"))
    }
}
