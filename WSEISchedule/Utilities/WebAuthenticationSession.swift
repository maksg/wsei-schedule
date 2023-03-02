//
//  WebAuthenticationSession.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 01/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import WebKit

protocol WebAuthenticationPresentationContextProviding: NSObjectProtocol {
    func presentationAnchor(for session: WebAuthenticationSession) -> WebAuthenticationSession.PresentationAnchor?
}

class WebAuthenticationSession: NSObject {
    typealias CompletionHandler = (Result<[HTTPCookie], Error>) -> Void
    typealias PresentationAnchor = UIWindow

    // MARK: - Properties

    weak var presentationContextProvider: WebAuthenticationPresentationContextProviding?

    private let navigationController: UINavigationController = UINavigationController()
    private let viewController: UIViewController = UIViewController()
    private let progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    private let webView: WKWebView = WKWebView()
    private let backButton: UIBarButtonItem = UIBarButtonItem()
    private let forwardButton: UIBarButtonItem = UIBarButtonItem()

    private let url: URL
    private let completionHandler: WebAuthenticationSession.CompletionHandler
    private let observation: NSKeyValueObservation

    private var timer: Timer?
    private var isPresented: Bool = false

    // MARK: - Initialization

    init(url: URL, completionHandler: @escaping WebAuthenticationSession.CompletionHandler) {
        self.url = url
        self.completionHandler = completionHandler

        self.observation = webView.observe(\.estimatedProgress, options: .new) { [weak progressView] _, change in
            guard let progressView, let progress = change.newValue else { return }

            if progressView.alpha == 0 {
                progressView.alpha = 1
                progressView.setProgress(0, animated: false)
            }

            progressView.setProgress(Float(progress), animated: true)

            if progress >= 1.0 {
                UIView.animate(withDuration: 1.0) {
                    progressView.alpha = 0
                }
            }
        }
    }

    // MARK: - Methods

    private func setupViewController() {
        viewController.edgesForExtendedLayout = []
        viewController.navigationItem.titleView = UILabel()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: dismiss))
        viewController.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(systemItem: .refresh, primaryAction: UIAction(handler: reload))
        ]

        updateNavigationItems()
        backButton.primaryAction = UIAction(image: .back, handler: goBack)
        forwardButton.primaryAction = UIAction(image: .forward, handler: goForward)
        let fixedSpace = UIBarButtonItem(systemItem: .fixedSpace)
        fixedSpace.width = 40
        viewController.toolbarItems = [
            backButton,
            fixedSpace,
            forwardButton,
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: .share, primaryAction: UIAction(handler: share))
        ]

        viewController.view.addSubview(webView)
        setupWebView(parent: viewController.view, delegate: self)

        viewController.view.addSubview(progressView)
        setupProgressView(parent: viewController.view)

        setupNavigationController()
        navigationController.viewControllers = [viewController]
    }

    private func updateNavigationItems() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward

        let label = viewController.navigationItem.titleView as? UILabel
        let host = webView.url?.host ?? ""

        let fullString = NSMutableAttributedString(string: host, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        label?.attributedText = fullString
        label?.sizeToFit()

        guard let serverTrust = webView.serverTrust else { return }
        DispatchQueue.global(qos: .background).async {
            guard SecTrustEvaluateWithError(serverTrust, nil) else { return }
            fullString.insert(NSAttributedString(string: " "), at: 0)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = .secure
            fullString.insert(NSAttributedString(attachment: imageAttachment), at: 0)

            DispatchQueue.main.async {
                label?.attributedText = fullString
                label?.sizeToFit()
            }
        }
    }

    private func setupNavigationController() {
        navigationController.setToolbarHidden(false, animated: false)

        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            let toolbarAppearance = UIToolbarAppearance()
            navigationController.toolbar.standardAppearance = toolbarAppearance
            navigationController.toolbar.scrollEdgeAppearance = toolbarAppearance
        }
    }

    private func setupWebView(parent: UIView, delegate: WKNavigationDelegate) {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true

        webView.navigationDelegate = delegate
    }

    private func setupProgressView(parent: UIView) {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }

    func start(silently: Bool = true) {
        setupViewController()

        let request = URLRequest(url: url)
        webView.load(request)

        if !silently {
            present()
        }
    }

    private func present() {
        let presentationAnchor = presentationContextProvider?.presentationAnchor(for: self)
        var topController = presentationAnchor?.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }

        guard let topController, !isPresented else { return }
        isPresented = true
        topController.present(navigationController, animated: true)
    }

    private func dismiss(_: UIAction) {
        navigationController.dismiss(animated: true)
    }

    private func reload(_: UIAction) {
        webView.reload()
    }

    private func goBack(_: UIAction) {
        webView.goBack()
    }

    private func goForward(_: UIAction) {
        webView.goForward()
    }

    private func share(_: UIAction) {
    }

    deinit {
        observation.invalidate()
    }

}

// MARK: - WKNavigationDelegate

extension WebAuthenticationSession: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        timer?.invalidate()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        completionHandler(.failure(error))
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        completionHandler(.failure(error))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavigationItems()

        if webView.url == URL(string: "https://dziekanat.wsei.edu.pl/") {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
                self?.completionHandler(.success(cookies))
                self?.navigationController.dismiss(animated: true)
            }
        } else if !isPresented {
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
                self?.present()
            }
        }
    }

}

