//
//  WebAuthenticationSession.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 01/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import WebKit

enum WebAuthenticationSessionError: Error {
    case cancelled
}

extension WebAuthenticationSessionError: LocalizedError {
    public var errorDescription: String? {
        return Translation.Error.unknown.localized
    }
}

protocol WebAuthenticationPresentationContextProviding: NSObjectProtocol {
    func presentationAnchor(for session: WebAuthenticationSession) -> WebAuthenticationSession.PresentationAnchor?
}

class WebAuthenticationSession: NSObject {
    typealias Success = ([HTTPCookie]) -> Void
    typealias Failure = (Error) -> Void
    typealias PresentationAnchor = UIWindow

    // MARK: - Properties

    weak var presentationContextProvider: WebAuthenticationPresentationContextProviding?

    private let navigationController: UINavigationController = UINavigationController()
    private let viewController: UIViewController = UIViewController()
    private let progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    private let backButton: UIBarButtonItem = UIBarButtonItem()
    private let forwardButton: UIBarButtonItem = UIBarButtonItem()
    private let secureImageView: UIImageView = UIImageView(image: .secure)
    private let titleLabel: UILabel = UILabel()
    private var webView: WKWebView!

    private let signInSuccessUrl: URL = URL(string: "https://dziekanat.wsei.edu.pl/")!
    private let url: URL
    var onSuccess: WebAuthenticationSession.Success?
    var onFailure: WebAuthenticationSession.Failure?

    private var timer: Timer?
    private var didRetry: Bool = false

    // MARK: - Initialization

    init(url: URL) {
        self.url = url

        super.init()

        setupViewController()
    }

    // MARK: - Methods

    func start(silently: Bool = true) {
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak webView] in
            webView?.load(request)
        }

        if !silently {
            DispatchQueue.main.async { [weak self] in
                self?.present()
            }
        }
    }

    private func setupViewController() {
        secureImageView.tintColor = .label
        secureImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.lineBreakMode = .byTruncatingHead

        let stackView = UIStackView(arrangedSubviews: [secureImageView, titleLabel])
        stackView.spacing = 8
        viewController.navigationItem.titleView = stackView

        viewController.edgesForExtendedLayout = []
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: dismiss))
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .refresh, primaryAction: UIAction(handler: reload))

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

        viewController.view.addSubview(progressView)
        setupProgressView(parent: viewController.view)

        setupNavigationController()
        navigationController.viewControllers = [viewController]

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.setupWebView(parent: self.viewController.view, delegate: self)
        }
    }

    private func updateNavigationItems() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward

        secureImageView.isHidden = true
        titleLabel.text = webView.url?.host ?? ""

        guard let serverTrust = webView.serverTrust else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard SecTrustEvaluateWithError(serverTrust, nil) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.secureImageView.isHidden = false
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
        guard webView == nil else { return }
        webView = WKWebView()
        parent.addSubview(webView)
        parent.bringSubviewToFront(progressView)
        updateNavigationItems()

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true

        webView.navigationDelegate = delegate
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    private func setupProgressView(parent: UIView) {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }

    private func present() {
        let presentationAnchor = presentationContextProvider?.presentationAnchor(for: self)
        var topController = presentationAnchor?.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }

        guard let topController, !navigationController.isModal else { return }
        navigationController.transitioningDelegate = self
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
        guard let url = webView.url else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = navigationController.view
        navigationController.present(activityViewController, animated: true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? WKWebView else { return }

        if keyPath == #keyPath(WKWebView.canGoBack) || keyPath == #keyPath(WKWebView.canGoForward) {
            updateNavigationItems()
        } else if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let progress = webView.estimatedProgress

            if progressView.alpha == 0 {
                progressView.alpha = 1
                progressView.setProgress(0, animated: false)
            }

            progressView.setProgress(Float(progress), animated: true)

            if progress >= 1.0 {
                UIView.animate(withDuration: 1.0) { [weak progressView] in
                    progressView?.alpha = 0
                }
            }
        }
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension WebAuthenticationSession: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        onFailure?(WebAuthenticationSessionError.cancelled)
        return nil
    }

}

// MARK: - WKNavigationDelegate

extension WebAuthenticationSession: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        timer?.invalidate()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        retry(error: error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        retry(error: error)
    }

    private func retry(error: Error) {
        guard !didRetry else {
            onFailure?(error)
            navigationController.dismiss(animated: true)
            return
        }

        didRetry = true
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast, completionHandler: {})
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavigationItems()

        if webView.url == signInSuccessUrl {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
                if let sessionIdCookie = cookies.first(where: { $0.name == "ASP.NET_SessionId" }) {
                    self?.onSuccess?([sessionIdCookie])
                } else {
                    self?.onSuccess?(cookies)
                }
                self?.navigationController.dismiss(animated: true)
            }
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    self?.present()
                }
            }
        }
    }

}
